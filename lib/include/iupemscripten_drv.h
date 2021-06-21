/** \file
 * \brief Emscripten Driver 
 *
 * See Copyright Notice in "iup.h"
 */
 
#ifndef __IUPEmscripten_DRV_H 
#define __IUPEmscripten_DRV_H

#ifdef __cplusplus
extern "C" {
#endif

#include "iup.h"
//#include "iup_object.h"

void iupEmscripten_AddWidgetToParent(Ihandle* ih);

void iupEmscripten_InitializeInternalGlobals(void);
void iupEmscripten_DestroyInternalGlobals(void);
void iupEmscripten_SetIntKeyForIhandleValue(int handle_id, Ihandle* ih);
void iupEmscripten_RemoveIntKeyFromIhandleMap(int handle_id);
Ihandle* iupEmscripten_GetIhandleValueForKey(int handle_id);

extern void emjsCommon_Alert(const char* message);
void iupEmscripten_Log(const char* restrict format, ...);

/* extern void emjsCommon_SetPosition(int handle_id, int x, int y, int height, int width); */

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
