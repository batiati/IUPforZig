#ifndef __IUP_ANDROID_JNI_MACROS_H 
#define __IUP_ANDROID_JNI_MACROS_H 

#ifdef __cplusplus
extern "C" {
#endif

#include <jni.h>


/*
These are a set of macros intended to replace standard JNI calls so we can 
semi-transparently enable/disable caching of JNI objects and IDs.
The macro syntax intentinally uses capitalization and spelling to match the 
function names that it replaces. This is intended to make searching/replacing the code easier.

The macros attempt to semantically match the functions they are intended to replace.
This is to help keep the JNI code feel consistent with orthodox JNI code 
that most people are familiar with since JNI code is so cumbersome to read.

To achieve the matching semantics, the GNU extension called "Statement Expressions"
is used, which "returns" the last statement in the macro block, 
almost like a return value from in a function. 
This allows us to have multi-line macros which still can be assigned to a variable 
on the left-hand side.
The extension appears to be available in clang, so we are good.


Much of the JNI discussion and literature encourages caching.
However, there is not a whole lot of specifics of real profile numbers.
There is also little discussion of trade-offs, like what kind and how many resources
are consumed by caching. 
Additionally, Android is notorious for not allocating enough resources for anything in the system,
from the number of dll's that could be opened, etc, so one should be extra cautious
about resources on Android.

So these marcos are intended to help toggling between enabled/disabled so we can experiment with both modes.

Of the discussion I've seen:
- IDs (like methodIDs and FieldIDs) seem to live the life of the JVM and don't get swept. Since these seem to be integers, the implication is that these don't have much overhead (and are lying around anyway), so why not cache them?
- NewGlobalRef's can have a little over 2000 on the emulator, but a lot more on the device. (I forgot the number, but I think it was around 60K.) 
	- So there is a potential resource limit danger if we have too many classes or objects cached. With the number of widgets in IUP and the pattern being employed, I predict we will be under the limit with a good margin, but if people use other libraries that take up a lot more, then problems ensue.
Part of the IupAndroid design is to have a Helper class for each widget category. 
The JNI caching issues make it tempting to have one uber Helper class so only one class needs to be cached.
But that's code I don't really want to maintain.


To use:

- Class Objects:

	- First you must declare a global or static variable for the cached object.
		- For classes that only need to be used from a single file, use IUPJNI_DECLARE_CLASS_STATIC at the top of the file (global area).
			IUPJNI_DECLARE_CLASS_STATIC(IupTimerHelper)	
	
		- For classes that will be used in multiple files, use IUPJNI_DECLARE_CLASS_EXTERN and IUPJNI_DECLARE_CLASS_GLOBAL.
			- In iupandroid_jnicacheglobals.c, add an entry for your new class:
				IUPJNI_DECLARE_CLASS_GLOBAL(IupTimerHelper)	
			- Then add to the iupandroid_jnicacheglobals.h:
				IUPJNI_DECLARE_CLASS_EXTERN(IupTimerHelper)	
			- Make sure any file that any file that uses the global has #include "iupandroid_jnicacheglobals.h"

	- Then replace your FindClass line, e.g. 
		jclass java_class = (*jni_env)->FindClass(jni_env, "br/pucrio/tecgraf/iup/IupTimerHelper");
		with
		jclass java_class = IUPJNI_FindClass(IupTimerHelper, jni_env, "br/pucrio/tecgraf/iup/IupTimerHelper");
		
	Make sure the varname parameter (e.g. IupTimerHelper) is the same in every macro parameter (it is case-sensitive). 
	The macros use these to synthesize the variable name that is used.

	Also remember that the normal JNI semantics are preserved with the macros.
	So this means you still typically want to call:
	(*jni_env)->DeleteLocalRef(jni_env, java_class);
	at the end of the function.
	(Internally, the macro calls NewGlobalRef and assigns to the variable you declared with the macro, so it is safe to clean up your local ref.)	

- Method IDs


	Caching Method IDs can be done in the way as Classes.

	But for simplicity, our convention to cache method IDs only uses static variables within the function you are in.
	This may be suboptimal if we call the same methods from different functions.
	However, because of Java overloading, this would need to make us even more careful about picking unique variable name parameters.
	(Unfortunately, the method signature cannot be easily converted into a variable name.)
	There are also a lot more methods to keep track of and because our code is in active development, methods change frequently,
	which is why a simpler approach is being employed.
	In case we do want to be more aggressive about caching in the future, I do recommend you defensively pick unique varable names.

	Additionally, if you do have a method that is used in multiple places in the same file,
	feel free to declare it at the top of the file.

	If you feel that it should be cached globally because it is used in a lot of different files, then 
	feel free to do so, after considering the likelyhood of the method needing to be changed in the future.

	Basic Pattern:

		- Declare the variable at the top of your function.
		IUPJNI_DECLARE_METHOD_ID_STATIC(IupTimer_stopTimer);
		By convention, I've been using ClassName_methodName, however remember to disambiguate if you have overloaded methods.

		- Then at the Get*MethodID call site, replace:
		jmethodID method_id = (*jni_env)->GetStaticMethodID(jni_env, java_class, "stopTimer", "(JLbr/pucrio/tecgraf/iup/IupTimer;)V");
		with the appropriate macro: (GetMethodID, GetStaticMethodID)
		method_id = IUPJNI_GetStaticMethodID(IupTimer_stopTimer, jni_env, java_class, "stopTimer", "(JLbr/pucrio/tecgraf/iup/IupTimer;)V");

		Since methodIDs don't get cleaned up in JNI, you don't need to do anything else.


	
///////////////////////////////////////////////////////////////////////////////			
	Comparison:
///////////////////////////////////////////////////////////////////////////////			

///////////////////////////////////////////////////////////////////////////////			
Macro JNI:
	This is how you should use the Macros. 
	Compare to the "Regular" version and see that it is almost 1-to-1,
	so it should feel very natural to how you normally write JNI code.
	Notice that you always clean up objects (not jmethodID's) 
	with DeleteLocalRef when you are done. The expanded/cached version 
	uses NewLocalRef to create temporary variables so things work out 
	in either case.

	Note: This is a simplified example. The real implementation is more complex due to needed featues.

///////////////////////////////////////////////////////////////////////////////			

#include <jni.h>
#include "iupandroid_jnimacros.h"
// #include "iupandroid_jnicacheglobals.h" // don't need for this example, but IupCommon is declared there.
IUPJNI_DECLARE_CLASS_STATIC(IupProgressBarHelper);

static int androidProgressBarMapMethod(Ihandle* ih)
{	
	JNIEnv* jni_env = iupAndroid_GetEnvThreadSafe();
	jclass java_class = IUPJNI_FindClass(IupLabelHelper, jni_env, "br/pucrio/tecgraf/iup/IupLabelHelper");

	IUPJNI_DECLARE_METHOD_ID_STATIC(IupProgressBarHelper_createProgressBar);

	jmethodID method_id = IUPJNI_GetStaticMethodID(IupProgressBarHelper_createProgressBar, jni_env, java_class, "createProgressBar", "(J)Landroid/widget/ProgressBar;");

	jobject java_widget = (*jni_env)->CallStaticObjectMethod(jni_env, java_class, method_id, (jlong)(intptr_t)ih);

	// In the cached case, this will clean up a NewLocalRef copy that the was created so it is consistent with the non-cached case.
	(*jni_env)->DeleteLocalRef(jni_env, java_class);



	// Below is not part of macro example, but just for completeness of the function.
	ih->handle = (jobject) ((*jni_env)->NewGlobalRef(jni_env, java_widget));
	(*jni_env)->DeleteLocalRef(jni_env, java_widget);
	// add to the parent, all Android controls must call this.
	iupAndroid_AddWidgetToParent(jni_env, ih);
	return IUP_NOERROR;
}


///////////////////////////////////////////////////////////////////////////////			
	Expanded/Transformed Non-Cached JNI (aka Regular JNI):
	This is the most straight-forward JNI code, which most people would write.
	Notice that the DECLARE macros get eliminated so there are no static variables.
///////////////////////////////////////////////////////////////////////////////			


#include <jni.h>

static int androidProgressBarMapMethod(Ihandle* ih)
{
	JNIEnv* jni_env = iupAndroid_GetEnvThreadSafe();

	jobject java_class = (*jni_env)->FindClass(jni_env, "br/pucrio/tecgraf/iup/IupProgressBarHelper");

	jmethodID method_id = (*jni_env)->GetStaticMethodID(jni_env, java_class, "createProgressBar", "(J)Landroid/widget/ProgressBar;");

	jobject java_widget = (*jni_env)->CallStaticObjectMethod(jni_env, java_class, method_id, (jlong)(intptr_t)ih);

	(*jni_env)->DeleteLocalRef(jni_env, java_class);



	// Below is not part of macro example, but just for completeness of the function.
	ih->handle = (jobject) ((*jni_env)->NewGlobalRef(jni_env, java_widget));
	(*jni_env)->DeleteLocalRef(jni_env, java_widget);
	// add to the parent, all Android controls must call this.
	iupAndroid_AddWidgetToParent(jni_env, ih);
	return IUP_NOERROR;
}





///////////////////////////////////////////////////////////////////////////////			
Expanded/Transformed Cached JNI:
	If caching is enabled, then the Macros are expanded to this.
///////////////////////////////////////////////////////////////////////////////			

#include <jni.h>
static jobject g_javaClassIupProgressBarHelper = NULL;

static int androidProgressBarMapMethod(Ihandle* ih)
{
	JNIEnv* jni_env = iupAndroid_GetEnvThreadSafe();

	jobject java_class;
	{
		jobject tmp_jclass_IupProgressBarHelper = NULL;
		if(NULL == g_javaClassIupProgressBarHelper)
		{
			tmp_jclass_IupProgressBarHelper = (*jni_env)->FindClass(jni_env, "br/pucrio/tecgraf/iup/IupProgressBarHelper");
			g_javaClassIupProgressBarHelper = (jobject)((*jni_env)->NewGlobalRef(jni_env, tmp_jclass_IupProgressBarHelper));
		}
		else
		{
			tmp_jclass_IupProgressBarHelper = (jobject)((*jni_env)->NewLocalRef(jni_env, g_javaClassIupProgressBarHelper));
		}
		java_class = tmp_jclass_IupProgressBarHelper;
	}



	static jmethodID s_methodID_IupProgressBarHelper_createProgressBar = 0;
	jmethodID method_id;
	{
		if(0 == s_methodID_IupProgressBarHelper_createProgressBar)
		{
			method_id = (*jni_env)->GetStaticMethodID(jni_env, java_class, "createProgressBar", "(J)Landroid/widget/ProgressBar;");
			s_methodID_IupProgressBarHelper_createProgressBar = method_id;
		}
		else
		{
			method_id = s_methodID_IupProgressBarHelper_createProgressBar;
		}
	}


	jobject java_widget = (*jni_env)->CallStaticObjectMethod(jni_env, java_class, method_id, (jlong)(intptr_t)ih);

	(*jni_env)->DeleteLocalRef(jni_env, java_class);



	// Below is not part of macro example, but just for completeness of the function.
	ih->handle = (jobject) ((*jni_env)->NewGlobalRef(jni_env, java_widget));
	(*jni_env)->DeleteLocalRef(jni_env, java_widget);
	// add to the parent, all Android controls must call this.
	iupAndroid_AddWidgetToParent(jni_env, ih);
	return IUP_NOERROR;
}




*/



#define IUP_ENABLE_CACHE_JAVA_CLASS 1
#define IUP_ENABLE_CACHE_JAVA_METHOD_ID 1

#if defined(IUP_ENABLE_CACHE_JAVA_CLASS) && (IUP_ENABLE_CACHE_JAVA_CLASS == 1)

	#define IUPJNI_DECLARE_CLASS_GLOBAL(varname) \
		jobject g_javaClass ## varname = NULL;

	#define IUPJNI_DECLARE_CLASS_STATIC(varname) \
		static jobject g_javaClass ## varname = NULL;

	#define IUPJNI_DECLARE_CLASS_EXTERN(varname) \
		extern jobject g_javaClass ## varname;
	

	#define IUPJNI_FindClass(varname, jni_env, classstr) \
	({ \
		jobject tmp_jclass_ ## varname = NULL; \
		if(NULL == g_javaClass ## varname) \
		{ \
			tmp_jclass_ ## varname = (*jni_env)->FindClass(jni_env, classstr); \
			g_javaClass ## varname = (jobject)((*jni_env)->NewGlobalRef(jni_env, tmp_jclass_ ## varname)); \
		} \
		else \
		{ \
			tmp_jclass_ ## varname = (jobject)((*jni_env)->NewLocalRef(jni_env, g_javaClass ## varname)); \
		} \
		tmp_jclass_ ## varname; \
	})

	#define IUPJNI_GetObjectClass(varname, jni_env, java_object) \
	({ \
		jobject tmp_jclass_ ## varname = NULL; \
		if(NULL == g_javaClass ## varname) \
		{ \
			tmp_jclass_ ## varname = (*jni_env)->GetObjectClass(jni_env, java_object); \
			g_javaClass ## varname = (jobject)((*jni_env)->NewGlobalRef(jni_env, tmp_jclass_ ## varname)); \
		} \
		else \
		{ \
			tmp_jclass_ ## varname = (jobject)((*jni_env)->NewLocalRef(jni_env, g_javaClass ## varname)); \
		} \
		tmp_jclass_ ## varname; \
	})


#else
	#define IUPJNI_DECLARE_CLASS_GLOBAL(varname)

	#define IUPJNI_DECLARE_CLASS_STATIC(varname)

	#define IUPJNI_DECLARE_CLASS_EXTERN(varname)

	#define IUPJNI_FindClass(varname, jni_env, classstr) \
		(*jni_env)->FindClass(jni_env, classstr);

	#define IUPJNI_GetObjectClass(varname, jni_env, java_object) \
		(*jni_env)->GetObjectClass(jni_env, java_object);

#endif





#if defined(IUP_ENABLE_CACHE_JAVA_METHOD_ID) && (IUP_ENABLE_CACHE_JAVA_METHOD_ID == 1)

	#define IUPJNI_DECLARE_METHOD_ID_GLOBAL(varname) \
		jmethodID s_methodID_ ## varname = 0;

	#define IUPJNI_DECLARE_METHOD_ID_STATIC(varname) \
		static jmethodID s_methodID_ ## varname = 0;

	#define IUPJNI_DECLARE_METHOD_ID_EXTERN(varname) \
		extern jmethodID s_methodID_ ## varname;

	#define IUPJNI_GetStaticMethodID(varname, jni_env, java_class, method_name, method_signature) \
	({ \
		if(0 == s_methodID_ ## varname) \
		{ \
			jmethodID method_id = (*jni_env)->GetStaticMethodID(jni_env, java_class, method_name, method_signature); \
			s_methodID_ ## varname = method_id; \
		} \
		s_methodID_ ## varname; \
	})

	#define IUPJNI_GetMethodID(varname, jni_env, java_class, method_name, method_signature) \
	({ \
		if(0 == s_methodID_ ## varname) \
		{ \
			jmethodID method_id = (*jni_env)->GetMethodID(jni_env, java_class, method_name, method_signature); \
			s_methodID_ ## varname = method_id; \
		} \
		s_methodID_ ## varname; \
	})


#else

	#define IUPJNI_DECLARE_METHOD_ID_GLOBAL(varname)
	#define IUPJNI_DECLARE_METHOD_ID_EXTERN(varname)
	#define IUPJNI_DECLARE_METHOD_ID_STATIC(varname)

	#define IUPJNI_GetStaticMethodID(varname, jni_env, java_class, method_name, method_signature) \
		(*jni_env)->GetStaticMethodID(jni_env, java_class, method_name, method_signature);

	#define IUPJNI_GetMethodID(varname, jni_env, java_class, method_name, method_signature) \
		(*jni_env)->GetMethodID(jni_env, java_class, method_name, method_signature);


#endif




#ifdef __cplusplus
}
#endif

#endif
