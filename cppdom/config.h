/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil c-basic-offset: 3 -*- */
// vim:cindent:ts=3:sw=3:et:tw=80:sta:
/*************************************************************** cppdom-cpr beg
 * 
 * cppdom was forked from the original xmlpp version 0.6 under the LGPL. This
 * new, branched xmlpp is under the same LGPL (of course) and is being
 * maintained by:
 *      Kevin Meinert   <subatomic@users.sourceforge.net>
 *      Allen Bierbaum  <allenb@users.sourceforge.net>
 *      Ben Scott       <nonchocoboy@users.sourceforge.net>
 *
 * -----------------------------------------------------------------
 *
 * xmlpp - an xml parser and validator written in C++
 * copyright (c) 2000-2001 Michael Fink
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * -----------------------------------------------------------------
 * File:          $RCSfile$
 * Date modified: $Date$
 * Version:       $Revision$
 * -----------------------------------------------------------------
 *
 ************************************************************ cppdom-cpr-end */
/*! \file config.h

  system dependent stuff

*/

#ifndef CPPDOM_CONFIG_H
#define CPPDOM_CONFIG_H

// -----------------------------------
// win32 configuration
#if defined(WIN32) || defined(WIN64)

// switch some warnings off
#  pragma warning( disable: 4786 4275 4251 )

// export/import #define's for building a win32 dll
#  ifdef CPPDOM_EXPORTS
#     define CPPDOM_EXPORT(ret)  __declspec(dllexport) ret __stdcall
#     define CPPDOM_CLASS        __declspec(dllexport)
#  else
#     define CPPDOM_EXPORT(ret)  __declspec(dllimport) ret __stdcall
#     define CPPDOM_CLASS        __declspec(dllimport)
#  endif

#else
#  define CPPDOM_EXPORT(ret) ret
#  define CPPDOM_CLASS
#endif

#ifdef _DEBUG
#define CPPDOM_DEBUG
#endif

// -----------------------------------
#endif
