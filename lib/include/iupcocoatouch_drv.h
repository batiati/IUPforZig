/** \file
 * \brief MAC Driver 
 *
 * See Copyright Notice in "iup.h"
 */
 
#ifndef __IUPMAC_DRV_H 
#define __IUPMAC_DRV_H

#ifdef __cplusplus
extern "C" {
#endif

// the point of this is we have a unique memory address for an identifier
extern const void* IHANDLE_ASSOCIATED_OBJ_KEY;


UIWindow* cocoaTouchFindCurrentWindow();
UIViewController* cocoaTouchFindCurrentRootViewController();
UINavigationController* cocoaTouchFindCurrentRootNavigationViewController();

UIColor *iupCocoaTouchToNativeColor(const char *inColor);
char *iupCocoaTouchColorFromNative(UIColor *color);
	
void iupCocoaTouchAddToParent(Ihandle* ih);
void iupCocoaTouchRemoveFromParent(Ihandle* ih);
// Cocoa is in Cartesian (a.k.a. math book, aka OpenGL coordinates, aka y increases upwards), but Iup is y increases downwards.
int iupCocoaComputeCartesianScreenHeightFromIup(int iup_height);
int iupCocoaComputeIupScreenHeightFromCartesian(int cartesian_height);

int iupCocoaTouchSetBgColorAttrib(Ihandle* ih, char *iColor);
char* iupCocoaTouchGetBGColorAttrib(Ihandle* ih);

int iupCocoaTouchSetActiveAttrib(Ihandle* ih, int enabled);

void iupCocoaTouchDoResize(Ihandle* ih, CGSize to_size, UIViewController* view_controller);

#if 0
/* global variables, declared in iupmac_globalattrib.c */
extern int iupmac_utf8autoconvert;         


/* common */
gboolean iupmacEnterLeaveEvent(GtkWidget *widget, GdkEventCrossing *evt, Ihandle* ih);
gboolean iupmacShowHelp(GtkWidget *widget, GtkWidgetHelpType *arg1, Ihandle* ih);
GtkFixed* iupmacBaseGetFixed(Ihandle* ih);
void iupmacBaseAddToParent(Ihandle* ih);
void iupgdkColorSet(GdkColor* color, unsigned char r, unsigned char g, unsigned char b);
int iupmacSetDragDropAttrib(Ihandle* ih, const char* value);
int iupmacSetMnemonicTitle(Ihandle* ih, GtkLabel* label, const char* value);
char* iupmacStrConvertToUTF8(const char* str);
char* iupmacStrConvertFromUTF8(const char* str);
void iupmacReleaseConvertUTF8(void);
char* iupmacStrConvertFromFilename(const char* str);
char* iupmacStrConvertToFilename(const char* str);
void iupmacUpdateMnemonic(Ihandle* ih);
gboolean iupmacMotionNotifyEvent(GtkWidget *widget, GdkEventMotion *evt, Ihandle *ih);
gboolean iupmacButtonEvent(GtkWidget *widget, GdkEventButton *evt, Ihandle *ih);
void iupmacBaseSetBgColor(InativeHandle* handle, unsigned char r, unsigned char g, unsigned char b);
void iupmacBaseSetFgColor(InativeHandle* handle, unsigned char r, unsigned char g, unsigned char b);
void iupmacBaseSetFgGdkColor(InativeHandle* handle, GdkColor *color);


/* focus */
gboolean iupmacFocusInOutEvent(GtkWidget *widget, GdkEventFocus *evt, Ihandle* ih);


/* key */
gboolean iupmacKeyPressEvent(GtkWidget *widget, GdkEventKey *evt, Ihandle* ih);
gboolean iupmacKeyReleaseEvent(GtkWidget *widget, GdkEventKey *evt, Ihandle* ih);
void iupmacButtonKeySetStatus(guint state, unsigned int but, char* status, int doubleclick);
void iupmacKeyEncode(int key, guint *keyval, guint *state);


/* font */
char* iupmacGetPangoFontDescAttrib(Ihandle *ih);
char* iupmacGetFontIdAttrib(Ihandle *ih);
PangoFontDescription* iupmacGetPangoFontDesc(const char* value);
char* iupmacFindPangoFontDesc(PangoFontDescription* fontdesc);
void iupmacFontUpdatePangoLayout(Ihandle* ih, PangoLayout* layout);
void iupmacFontUpdateObjectPangoLayout(Ihandle* ih, gpointer object);


/* open */
char* iupmacGetNativeWindowHandle(Ihandle* ih);
void iupmacPushVisualAndColormap(void* visual, void* colormap);
void* iupmacGetNativeGraphicsContext(GtkWidget* widget);
void iupmacReleaseNativeGraphicsContext(GtkWidget* widget, void* gc);
void iupmacUpdateGlobalColors(GtkStyle* style);


/* dialog */
gboolean iupmacDialogDeleteEvent(GtkWidget *widget, GdkEvent *evt, Ihandle *ih);

#endif

#ifdef __cplusplus
}
#endif

#endif
