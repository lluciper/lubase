l10n:
	dart run intl_utils:generate

gen:
	dart run build_runner build

pub_get: 
	flutter pub get

init: pub_get gen l10n

# Same checks as CI (minus the generated-files diff).
check:
	dart analyze --fatal-infos
	flutter test

	