#pragma once

#include <memory>

#ifdef LE_PLATFORM_WINDOWS
#if LE_DYNAMIC_LINK
#ifdef LE_BUILD_DLL
#define LITEENGINE_API __declspec(dllexport)
#else
#define LITEENGINE_API __declspec(dllimport)
#endif
#else
#define LITEENGINE_API      // Static lib: no dllexport/import needed
#endif
#define LE_DEBUGBREAK() __debugbreak()
#elif defined(LE_PLATFORM_MACOS) || defined(LE_PLATFORM_LINUX)
#define LITEENGINE_API
#define LE_DEBUGBREAK() __builtin_trap()
#else
#error LiteEngine only supports Windows, macOS, and Linux!
#endif

#ifdef LE_DEBUG
#define LE_ENABLE_ASSERTS
#endif

#ifdef LE_ENABLE_ASSERTS
#define LE_ASSERT(x, ...) { if(!(x)) { LE_ERROR("Assertion Failed: {0}", __VA_ARGS__); LE_DEBUGBREAK(); } }
#define LE_CORE_ASSERT(x, ...) { if(!(x)) { LE_CORE_ERROR("Assertion Failed: {0}", __VA_ARGS__); LE_DEBUGBREAK(); } }
#else
#define LE_ASSERT(x, ...)
#define LE_CORE_ASSERT(x, ...)
#endif

#define BIT(x) (1 << x)

#define LE_BIND_EVENT_FN(fn) std::bind(&fn, this, std::placeholders::_1)

namespace LiteEngine {

	template<typename T>
	using Scope = std::unique_ptr<T>;

	template<typename T>
	using Ref = std::shared_ptr<T>;

}