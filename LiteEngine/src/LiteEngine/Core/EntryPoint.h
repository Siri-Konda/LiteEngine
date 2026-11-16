#pragma once

#if defined(LE_PLATFORM_WINDOWS) || defined(LE_PLATFORM_MACOS) || defined(LE_PLATFORM_LINUX)

extern LiteEngine::Application* LiteEngine::CreateApplication();

int main(int argc, char** argv)
{
	LiteEngine::Log::Init();
	LE_CORE_WARN("Initialized Log!");

	auto app = LiteEngine::CreateApplication();
	app->Run();
	delete app;
}

#endif