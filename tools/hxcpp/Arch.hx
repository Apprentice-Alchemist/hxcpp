@:using(Arch.ArchTools)
enum Arch {
	X86;
	X86_64;
	Arm64;
	Arm64_32;
	Armv7;
	Armv7s;
	Armv7k;
	Armv6;
	Other(value:String);
}

class ArchTools {
	public static var archFlags:Map<String, Arch> = [
		"HXCPP_M32" => X86,
		"HXCPP_X86" => X86,
		"HXCPP_M64" => X86_64,
		"HXCPP_X86_64" => X86_64,
		"HXCPP_ARM64" => Arm64,
		"HXCPP_ARM64_32" => Arm64_32,
		"HXCPP_LINUX_ARM64" => Arm64,
		"HXCPP_ARMV6" => Armv6,
		"HXCPP_ARMV7" => Armv7,
		"HXCPP_LINUX_ARMV7" => Armv7,
		"HXCPP_ARMV7S" => Armv7s,
	];

	public static function fromFlags(defines: BuildTool.Hash<String>): Null<Arch> {

		var targetArch = null;

		if (defines.exists("HXCPP_ARCH")) {
			targetArch = fromString(defines.get("HXCPP_ARCH"));
		}

		for (flag => arch in archFlags) {
			if (defines.exists(flag)) {
				if (targetArch != null) {
					Log.error("Multiple architectures specified");
				}
				targetArch = arch;
			}
		}

		return targetArch;
	}

	public static function fromString(val: String): Arch {
		return switch val {
			case "i686", "x86": X86;
			case "x86_64", "amd64": X86_64;
			case "aarch64", "arm64": Arm64;
			case "arm64_32": Arm64_32;
			case "armv7": Armv7;
			case "armv7s": Armv7s;
			case "armv7k": Armv7k;
			case "armv6": Armv6;
			case var val: Other(val);
		};
	}

	public static function toDarwin(arch: Arch): String {
		return switch arch {
			case X86: "i686";
			case X86_64: "x86_64";
			case Arm64: "arm64";
			case Arm64_32: "arm64_32";
			case Armv7: "armv7";
			case Armv7s: "armv7s";
			case Armv7k: "armv7k";
			case Armv6: "armv6";
			case Other(val):
				Log.error('Unsupported architecture for Apple OS: $val');
				"";
		}
	}

	public static function getAndroidFlag(arch: Arch): String {
		return switch arch {
			case X86: "HXCPP_X86";
			case X86_64: "HXCPP_X86_64";
			case Arm64: "HXCPP_ARM64";
			case Armv7: "HXCPP_ARMV7";
			case var val:
				Log.error('Unsupported architecture for Android: $val');
				"";
		}
	}
}