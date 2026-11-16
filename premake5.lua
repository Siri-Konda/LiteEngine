workspace "LiteEngine"
    if os.host() == "macosx" then
        local arch = os.outputof("uname -m")
        if arch == "arm64" then
            architecture "ARM64"
        else
            architecture "x64"
        end
    else
        architecture "x64"
    end

    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["GLFW"]      = "LiteEngine/vendor/GLFW/include"
IncludeDir["Glad"]      = "LiteEngine/vendor/Glad/include"
IncludeDir["ImGui"]     = "LiteEngine/vendor/imgui"
IncludeDir["glm"]       = "LiteEngine/vendor/glm"
IncludeDir["stb_image"] = "LiteEngine/vendor/stb_image"
IncludeDir["miniaudio"] = "Sandbox/vendor/miniaudio"

include "LiteEngine/vendor/GLFW"
include "LiteEngine/vendor/Glad"

project "ImGui"
    location "LiteEngine/vendor/imgui"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "LiteEngine/vendor/imgui/imconfig.h",
        "LiteEngine/vendor/imgui/imgui.h",
        "LiteEngine/vendor/imgui/imgui.cpp",
        "LiteEngine/vendor/imgui/imgui_draw.cpp",
        "LiteEngine/vendor/imgui/imgui_internal.h",
        "LiteEngine/vendor/imgui/imgui_widgets.cpp",
        "LiteEngine/vendor/imgui/imstb_rectpack.h",
        "LiteEngine/vendor/imgui/imstb_textedit.h",
        "LiteEngine/vendor/imgui/imstb_truetype.h",
        "LiteEngine/vendor/imgui/imgui_demo.cpp"
    }

    filter "system:windows"
        systemversion "latest"
        staticruntime "On"

    filter "system:macosx"
        toolset "clang"
        pic "On"

    filter "system:linux"
        pic "On"

    filter { "system:windows", "configurations:Release" }
        buildoptions "/MT"

    filter "configurations:Debug"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        runtime "Release"
        optimize "on"

    filter "configurations:Dist"
        runtime "Release"
        optimize "on"
        
project "LiteEngine"
    location "LiteEngine"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    staticruntime "on"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp",
        "%{prj.name}/vendor/stb_image/**.h",
        "%{prj.name}/vendor/stb_image/**.cpp",
        "%{prj.name}/vendor/glm/glm/**.hpp",
        "%{prj.name}/vendor/glm/glm/**.inl"
    }

    defines
    {
        "_CRT_SECURE_NO_WARNINGS",
        "GLFW_INCLUDE_NONE"
    }

    includedirs
    {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}",
        "%{IncludeDir.ImGui}",
        "%{IncludeDir.glm}",
        "%{IncludeDir.stb_image}"
    }

    filter "system:windows"
        systemversion "latest"
        pchheader "hzpch.h"
        pchsource "LiteEngine/src/hzpch.cpp"
        buildoptions { "/utf-8" }
        linkoptions { "/ignore:4006" }
        includedirs
        {
            "%{prj.name}/vendor/freetype/include"
        }
        defines
        {
            "LE_PLATFORM_WINDOWS"
        }
        links
        {
            "GLFW",
            "Glad",
            "ImGui",
            "opengl32.lib",
            "dwmapi.lib",
            "%{wks.location}/LiteEngine/vendor/freetype/lib/freetype"
        }

    filter "system:macosx"
        toolset "clang"
        pic "On"
        includedirs
        {
            "/opt/homebrew/include/freetype2",
            "/usr/local/include/freetype2"
        }
        defines
        {
            "LE_PLATFORM_MACOS",
            "GL_SILENCE_DEPRECATION"
        }

    filter "system:linux"
        pic "On"
        includedirs
        {
            "/usr/include/freetype2"
        }
        defines
        {
            "LE_PLATFORM_LINUX"
        }

    filter "configurations:Debug"
        defines "LE_DEBUG"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "LE_RELEASE"
        runtime "Release"
        optimize "on"

    filter "configurations:Dist"
        defines "LE_DIST"
        runtime "Release"
        optimize "on"


project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++17"
    staticruntime "on"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "LiteEngine/vendor/spdlog/include",
        "LiteEngine/src",
        "LiteEngine/vendor",
        "%{IncludeDir.glm}",
        "%{IncludeDir.miniaudio}"
    }

    filter "system:windows"
        systemversion "latest"
        buildoptions { "/utf-8" }
        linkoptions { "/ignore:4006", "/NODEFAULTLIB:LIBCMT" }
        includedirs
        {
            "LiteEngine/vendor/freetype/include"
        }
        defines
        {
            "LE_PLATFORM_WINDOWS"
        }
        links
        {
            "LiteEngine"
        }

    filter "system:macosx"
        toolset "clang"
        pic "On"
        includedirs
        {
            "/opt/homebrew/include/freetype2",
            "/usr/local/include/freetype2"
        }
        libdirs
        {
            "/opt/homebrew/lib",
            "/usr/local/lib"
        }
        defines
        {
            "LE_PLATFORM_MACOS",
            "GL_SILENCE_DEPRECATION"
        }
        links
        {
            "LiteEngine",
            "GLFW",
            "Glad",
            "ImGui",
            "freetype",
            "Cocoa.framework",
            "IOKit.framework",
            "CoreVideo.framework",
            "OpenGL.framework",
            "CoreFoundation.framework",
            "CoreAudio.framework",
            "AudioToolbox.framework"
        }

    filter "system:linux"
        pic "On"
        includedirs
        {
            "/usr/include/freetype2"
        }
        defines
        {
            "LE_PLATFORM_LINUX"
        }
        links
        {
            "LiteEngine",
            "GLFW",
            "Glad",
            "ImGui",
            "freetype",
            "GL",
            "X11",
            "pthread",
            "dl",
            "m"
        }

    filter "configurations:Debug"
        defines "LE_DEBUG"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "LE_RELEASE"
        runtime "Release"
        optimize "on"

    filter "configurations:Dist"
        defines "LE_DIST"
        runtime "Release"
        optimize "on"