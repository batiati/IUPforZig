/** \file
 * \brief GTK Driver 
 *
 * See Copyright Notice in "iup.h"
 */
 
#ifndef __IUPGTK_DRV_H 
#define __IUPGTK_DRV_H


#ifdef __cplusplus
class BView;
class BHandler;

BView* viewFromHandler(BHandler* handler);

extern "C" {
#endif

#define iupCOLORDoubleTO8(_x) ((unsigned char)(_x*255))  /* 1.0*255 = 255 */
#define iupCOLOR8ToDouble(_x) ((double)_x/255.0)


/* global variables, declared in iupgtk_globalattrib.c */
extern int iupgtk_utf8autoconvert;         
extern int iupgtk_globalmenu;


/* common */
void iuphaikuBaseAddToParent(Ihandle* ih);
char* iuphaikuStrConvertToUTF8(const char* str);
char* iuphaikuStrConvertFromUTF8(const char* str);
void iupgtkReleaseConvertUTF8(void);
char* iupgtkStrConvertFromFilename(const char* str);
char* iupgtkStrConvertToFilename(const char* str);
void iupgtkUpdateMnemonic(Ihandle* ih);
void iuphaikuBaseSetBgColor(InativeHandle* handle, unsigned char r, unsigned char g, unsigned char b);
void iuphaikuBaseSetFgColor(InativeHandle* handle, unsigned char r, unsigned char g, unsigned char b);


/* key */

/* font */
char* iupgtkGetPangoFontDescAttrib(Ihandle *ih);
char* iupgtkGetPangoLayoutAttrib(Ihandle *ih);
char* iupgtkGetFontIdAttrib(Ihandle *ih);

/* There are PANGO_SCALE Pango units in one device unit. 
  For an output backend where a device unit is a pixel, 
  a size value of 10 * PANGO_SCALE gives 10 pixels. */
#define iupGTK_PANGOUNITS2PIXELS(_x) (((_x) + PANGO_SCALE/2) / PANGO_SCALE)
#define iupGTK_PIXELS2PANGOUNITS(_x) ((_x) * PANGO_SCALE)


/* open */
char* iupgtkGetNativeWindowHandle(Ihandle* ih);
void iupgtkPushVisualAndColormap(void* visual, void* colormap);

enum messageConstants {
  buttonInvoke   = 'buti',
  checkboxInvoke = 'cbxi',
  listInvoke     = 'linv',
  listSelect     = 'lsel',
  menuInvoke     = 'meni',
  timerFire      = 'time',
};

#ifdef __cplusplus
}
#endif

#endif
