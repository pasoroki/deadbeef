workspace "deadbeef"
   configurations { "Debug", "Release" }

includedirs { "plugins/libmp4ff", "static-deps/lib-x86-64/include/x86_64-linux-gnu", "static-deps/lib-x86-64/include"  }
libdirs { "static-deps/lib-x86-64/lib/x86_64-linux-gnu", "static-deps/lib-x86-64/lib" }


defines {
    "VERSION=\"devel\"",
    "_GNU_SOURCE",
    "HAVE_LOG2=1"
}

buildoptions { "-fPIC" }

filter "configurations:Debug"
  defines { "DEBUG" }
  symbols "On"

filter "configurations:Release"
  defines { "NDEBUG" }
  optimize "On"

project "deadbeef"
   kind "ConsoleApp"
   language "C"
   targetdir "bin/%{cfg.buildcfg}"

   files {
       "*.h",
       "*.c",
       "md5/*.h",
       "md5/*.c",
       "plugins/libparser/*.h",
       "plugins/libparser/*.c",
       "ConvertUTF/*.h",
       "ConvertUTF/*.c"
   }

   defines { "PORTABLE=1", "STATICLINK=1", "PREFIX=\"donotuse\"", "LIBDIR=\"donotuse\"", "DOCDIR=\"donotuse\"" }
   links { "m", "pthread", "dl" }

project "mp3"
   kind "SharedLib"
   language "C"
   targetdir "bin/%{cfg.buildcfg}/plugins"
   targetprefix ""

   files {
       "plugins/mp3/*.h",
       "plugins/mp3/*.c",
   }

   defines { "USE_LIBMPG123=1", "USE_LIBMAD=1" }
   links { "mpg123", "mad" }

project "flac_plugin"
   kind "SharedLib"
   language "C"
   targetdir "bin/%{cfg.buildcfg}/plugins"
   targetprefix ""
   targetname "flac"

   files {
       "plugins/flac/*.h",
       "plugins/flac/*.c",
       "plugins/liboggedit/*.h",
       "plugins/liboggedit/*.c",
   }

   defines { "HAVE_OGG_STREAM_FLUSH_FILL" }
   links { "FLAC", "ogg" }

project "wavpack_plugin"
   kind "SharedLib"
   language "C"
   targetdir "bin/%{cfg.buildcfg}/plugins"
   targetprefix ""
   targetname "wavpack"

   files {
       "plugins/wavpack/*.h",
       "plugins/wavpack/*.c",
   }

   links { "wavpack" }

project "vorbis_plugin"
   kind "SharedLib"
   language "C"
   targetdir "bin/%{cfg.buildcfg}/plugins"
   targetprefix ""
   targetname "vorbis"

   files {
       "plugins/vorbis/*.h",
       "plugins/vorbis/*.c",
       "plugins/liboggedit/*.h",
       "plugins/liboggedit/*.c",
   }

   defines { "HAVE_OGG_STREAM_FLUSH_FILL" }
   links { "vorbisfile", "vorbis", "m", "ogg" }

project "ffap"
   kind "SharedLib"
   language "C"
   targetdir "bin/%{cfg.buildcfg}/plugins"
   targetprefix ""

   files {
       "plugins/ffap/*.h",
       "plugins/ffap/*.c",
       "plugins/ffap/dsputil_yasm.asm",
   }

   filter 'files:**.asm'
       buildmessage 'YASM Assembling : %{file.relpath}'

       buildcommands
       {
           'yasm -f elf -D ARCH_X86_64 -m amd64 -DPIC -DPREFIX -o "obj/%{cfg.buildcfg}/ffap/%{file.basename}.o" "%{file.relpath}"'
       }

       buildoutputs
       {
           "obj/%{cfg.buildcfg}/ffap/%{file.basename}.o"
       }

   defines { "APE_USE_ASM=yes", "ARCH_X86_64=1" }

project "hotkeys"
   kind "SharedLib"
   language "C"
   targetdir "bin/%{cfg.buildcfg}/plugins"
   targetprefix ""

   files {
       "plugins/hotkeys/*.h",
       "plugins/hotkeys/*.c",
       "plugins/libparser/*.h",
       "plugins/libparser/*.c",
   }

   links { "X11" }

project "alsa"
   kind "SharedLib"
   language "C"
   targetdir "bin/%{cfg.buildcfg}/plugins"
   targetprefix ""

   files {
       "plugins/alsa/*.h",
       "plugins/alsa/*.c",
   }

   links { "asound" }

project "ddb_gui_GTK2"
   kind "SharedLib"
   language "C"
   targetdir "bin/%{cfg.buildcfg}/plugins"
   targetprefix ""

   includedirs { "static-deps/lib-x86-64/gtk-2.16.0/include/**", "static-deps/lib-x86-64/gtk-2.16.0/lib/**", "plugins/gtkui", "plugins/libparser" }
   libdirs { "static-deps/lib-x86-64/gtk-2.16.0/lib", "static-deps/lib-x86-64/gtk-2.16.0/lib/**" }

   files {
       "plugins/gtkui/*.h",
       "plugins/gtkui/*.c",
       "shared/pluginsettings.h",
       "shared/pluginsettings.c",
       "shared/trkproperties_shared.h",
       "shared/trkproperties_shared.c",
       "plugins/libparser/parser.h",
       "plugins/libparser/parser.c",
       "utf8.c",
   }

   links { "jansson", "gtk-x11-2.0", "pango-1.0", "cairo", "gdk-x11-2.0", "gdk_pixbuf-2.0", "gobject-2.0", "gthread-2.0", "glib-2.0" }

project "rg_scanner"
   kind "SharedLib"
   language "C"
   targetdir "bin/%{cfg.buildcfg}/plugins"
   targetprefix ""

   files {
       "plugins/rg_scanner/*.h",
       "plugins/rg_scanner/*.c",
       "plugins/rg_scanner/ebur128/*.h",
       "plugins/rg_scanner/ebur128/*.c",
   }

project "converter"
   kind "SharedLib"
   language "C"
   targetdir "bin/%{cfg.buildcfg}/plugins"
   targetprefix ""

   defines {
      "USE_TAGGING=1"
   }
   files {
       "plugins/converter/converter.c",
       "plugins/libmp4ff/*.c",
       "shared/mp4tagutil.c",
   }

project "converter_gtk2"
   kind "SharedLib"
   language "C"
   targetdir "bin/%{cfg.buildcfg}/plugins"
   targetprefix ""

   files {
       "plugins/converter/convgui.c",
       "plugins/converter/callbacks.c",
       "plugins/converter/interface.c",
       "plugins/converter/support.c",
   }
   includedirs { "static-deps/lib-x86-64/gtk-2.16.0/include/**", "static-deps/lib-x86-64/gtk-2.16.0/lib/**", "plugins/gtkui", "plugins/libparser" }
   libdirs { "static-deps/lib-x86-64/gtk-2.16.0/lib", "static-deps/lib-x86-64/gtk-2.16.0/lib/**" }

   links { "gtk-x11-2.0", "pango-1.0", "cairo", "gdk-x11-2.0", "gdk_pixbuf-2.0", "gobject-2.0", "gthread-2.0", "glib-2.0" }

project "resources"
    kind "Utility"
    postbuildcommands {
        "mkdir -p bin/%{cfg.buildcfg}/pixmaps",
        "cp icons/32x32/deadbeef.png bin/%{cfg.buildcfg}",
        "cp pixmaps/*.png pixmaps/*.svg bin/%{cfg.buildcfg}/pixmaps/",
        "mkdir -p bin/%{cfg.buildcfg}/plugins/convpresets",
        "cp -r plugins/converter/convpresets bin/%{cfg.buildcfg}/plugins/",
    }

