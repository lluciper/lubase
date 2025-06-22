l10n:
	flutter pub global run intl_utils:generate

gen:
	flutter pub run build_runner build --delete-conflicting-outputs

# dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs

pre_start:
	@if [ ! -f lib/generated/l10n.dart ]; then \
		echo "Generating localization files..."; \
		$(FLUTTER) pub global run intl_utils:generate; \
	fi
	@if [ ! -d lib/src/generated ]; then \
		echo "Running build_runner..."; \
		dart run build_runner build --delete-conflicting-outputs; \
	fi
	@if [ ! -f lib/config/env.g.dart ]; then \
		echo "Generating env files..."; \
		dart pub get --directory=tools/gen_env; \
		dart run tools/gen_env/lib/main.dart; \
	fi

run: pre_start
	$(FLUTTER) run