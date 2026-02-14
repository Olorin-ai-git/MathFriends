#!/usr/bin/env python3
"""
Generate Xcode project for MathFriends iOS app
Creates project.pbxproj file with all source files properly configured
"""

import os
import uuid
from pathlib import Path

def generate_uuid():
    """Generate a 24-character hex UUID (Xcode format)"""
    return uuid.uuid4().hex[:24].upper()

class XcodeProjectGenerator:
    def __init__(self, project_name, bundle_id, source_dir):
        self.project_name = project_name
        self.bundle_id = bundle_id
        self.source_dir = Path(source_dir)
        self.file_refs = {}
        self.group_refs = {}
        self.build_file_refs = {}

    def scan_source_files(self):
        """Scan source directory and collect all Swift files"""
        swift_files = []
        for root, dirs, files in os.walk(self.source_dir):
            # Skip hidden directories and build folders
            dirs[:] = [d for d in dirs if not d.startswith('.') and d not in ['build', 'DerivedData']]

            for file in files:
                if file.endswith('.swift'):
                    rel_path = os.path.relpath(os.path.join(root, file), self.source_dir)
                    swift_files.append(rel_path)

        return sorted(swift_files)

    def generate_file_references(self, files):
        """Generate PBXFileReference entries for all files"""
        refs = []
        for file_path in files:
            file_uuid = generate_uuid()
            file_name = os.path.basename(file_path)

            self.file_refs[file_path] = file_uuid

            refs.append(f"""		{file_uuid} /* {file_name} */ = {{
			isa = PBXFileReference;
			lastKnownFileType = sourcecode.swift;
			path = {file_name};
			sourceTree = "<group>";
		}};""")

        return "\n".join(refs)

    def generate_build_files(self, files):
        """Generate PBXBuildFile entries"""
        refs = []
        for file_path in files:
            build_uuid = generate_uuid()
            file_uuid = self.file_refs[file_path]
            file_name = os.path.basename(file_path)

            self.build_file_refs[file_path] = build_uuid

            refs.append(f"""		{build_uuid} /* {file_name} in Sources */ = {{
			isa = PBXBuildFile;
			fileRef = {file_uuid} /* {file_name} */;
		}};""")

        return "\n".join(refs)

    def generate_groups(self, files):
        """Generate PBXGroup entries for folder structure"""
        # Organize files by directory
        groups_dict = {}
        for file_path in files:
            dir_path = os.path.dirname(file_path)
            if dir_path:
                if dir_path not in groups_dict:
                    groups_dict[dir_path] = []
                groups_dict[dir_path].append(file_path)

        # Generate group UUIDs
        for group_path in groups_dict.keys():
            self.group_refs[group_path] = generate_uuid()

        # Main group
        main_group_uuid = generate_uuid()
        self.group_refs['main'] = main_group_uuid

        # Root files (no subdirectory)
        root_files = [f for f in files if not os.path.dirname(f)]

        # Build children list for main group
        main_children = []
        for file_path in root_files:
            main_children.append(f"{self.file_refs[file_path]} /* {os.path.basename(file_path)} */")

        # Add subdirectory groups
        top_level_dirs = set(p.split('/')[0] for p in groups_dict.keys())
        for dir_name in sorted(top_level_dirs):
            main_children.append(f"{self.group_refs[dir_name]} /* {dir_name} */")

        # Generate group entries
        groups = []

        # Main group
        groups.append(f"""		{main_group_uuid} /* {self.project_name} */ = {{
			isa = PBXGroup;
			children = (
				{chr(10).join('				' + c + ',' for c in main_children)}
			);
			path = {self.project_name};
			sourceTree = "<group>";
		}};""")

        # Subdirectory groups
        for group_path in sorted(groups_dict.keys()):
            group_name = os.path.basename(group_path)
            children = []
            for file_path in groups_dict[group_path]:
                if os.path.dirname(file_path) == group_path:
                    children.append(f"{self.file_refs[file_path]} /* {os.path.basename(file_path)} */")

            # Add subgroups
            subgroups = [p for p in groups_dict.keys() if p.startswith(group_path + '/') and p.count('/') == group_path.count('/') + 1]
            for subgroup in subgroups:
                children.append(f"{self.group_refs[subgroup]} /* {os.path.basename(subgroup)} */")

            groups.append(f"""		{self.group_refs[group_path]} /* {group_name} */ = {{
			isa = PBXGroup;
			children = (
				{chr(10).join('				' + c + ',' for c in children)}
			);
			path = {group_name};
			sourceTree = "<group>";
		}};""")

        return "\n".join(groups)

    def generate_sources_build_phase(self, files):
        """Generate PBXSourcesBuildPhase"""
        sources_uuid = generate_uuid()
        self.sources_build_phase_uuid = sources_uuid

        build_files = [f"{self.build_file_refs[f]} /* {os.path.basename(f)} in Sources */" for f in files]

        return f"""		{sources_uuid} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				{chr(10).join('				' + bf + ',' for bf in build_files)}
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};"""

    def generate_project_pbxproj(self, files):
        """Generate complete project.pbxproj file"""
        # Generate UUIDs for main objects
        project_uuid = generate_uuid()
        target_uuid = generate_uuid()
        config_list_project_uuid = generate_uuid()
        config_list_target_uuid = generate_uuid()
        debug_config_uuid = generate_uuid()
        release_config_uuid = generate_uuid()
        target_debug_config_uuid = generate_uuid()
        target_release_config_uuid = generate_uuid()
        frameworks_build_phase_uuid = generate_uuid()
        resources_build_phase_uuid = generate_uuid()
        product_ref_uuid = generate_uuid()
        products_group_uuid = generate_uuid()

        # Store for later use
        self.project_uuid = project_uuid
        self.target_uuid = target_uuid
        self.product_ref_uuid = product_ref_uuid

        file_references = self.generate_file_references(files)
        build_files = self.generate_build_files(files)
        groups = self.generate_groups(files)
        main_group_uuid = self.group_refs['main']
        project_root_uuid = generate_uuid()
        sources_build_phase = self.generate_sources_build_phase(files)

        pbxproj = f"""// !$*UTF8*$!
{{
	archiveVersion = 1;
	classes = {{
	}};
	objectVersion = 56;
	objects = {{

/* Begin PBXBuildFile section */
{build_files}
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
{file_references}
		{product_ref_uuid} /* {self.project_name}.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = {self.project_name}.app; sourceTree = BUILT_PRODUCTS_DIR; }};
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		{frameworks_build_phase_uuid} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		{project_root_uuid} = {{
			isa = PBXGroup;
			children = (
				{main_group_uuid} /* {self.project_name} */,
				{products_group_uuid} /* Products */,
			);
			sourceTree = "<group>";
		}};
{groups}
		{products_group_uuid} /* Products */ = {{
			isa = PBXGroup;
			children = (
				{product_ref_uuid} /* {self.project_name}.app */,
			);
			name = Products;
			sourceTree = "<group>";
		}};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		{target_uuid} /* {self.project_name} */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {config_list_target_uuid} /* Build configuration list for PBXNativeTarget "{self.project_name}" */;
			buildPhases = (
				{self.sources_build_phase_uuid} /* Sources */,
				{frameworks_build_phase_uuid} /* Frameworks */,
				{resources_build_phase_uuid} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = {self.project_name};
			productName = {self.project_name};
			productReference = {product_ref_uuid} /* {self.project_name}.app */;
			productType = "com.apple.product-type.application";
		}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		{project_uuid} /* Project object */ = {{
			isa = PBXProject;
			attributes = {{
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {{
					{target_uuid} = {{
						CreatedOnToolsVersion = 15.0;
					}};
				}};
			}};
			buildConfigurationList = {config_list_project_uuid} /* Build configuration list for PBXProject "{self.project_name}" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = {project_root_uuid};
			productRefGroup = {products_group_uuid} /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				{target_uuid} /* {self.project_name} */,
			);
		}};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		{resources_build_phase_uuid} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
{sources_build_phase}
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		{debug_config_uuid} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			}};
			name = Debug;
		}};
		{release_config_uuid} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				VALIDATE_PRODUCT = YES;
			}};
			name = Release;
		}};
		{target_debug_config_uuid} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = {self.project_name}/{self.project_name}/Info.plist;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = {self.bundle_id};
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Debug;
		}};
		{target_release_config_uuid} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = {self.project_name}/{self.project_name}/Info.plist;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = {self.bundle_id};
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Release;
		}};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		{config_list_project_uuid} /* Build configuration list for PBXProject "{self.project_name}" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{debug_config_uuid} /* Debug */,
				{release_config_uuid} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
		{config_list_target_uuid} /* Build configuration list for PBXNativeTarget "{self.project_name}" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{target_debug_config_uuid} /* Debug */,
				{target_release_config_uuid} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
/* End XCConfigurationList section */
	}};
	rootObject = {project_uuid} /* Project object */;
}}
"""
        return pbxproj

def main():
    project_name = "MathFriends"
    bundle_id = "com.mathfriends.app"
    source_dir = "/Users/olorin/Documents/Projects/MathFriends/ios/MathFriends/MathFriends"

    # Create generator
    generator = XcodeProjectGenerator(project_name, bundle_id, source_dir)

    # Scan source files
    print(f"Scanning source files in: {source_dir}")
    swift_files = generator.scan_source_files()
    print(f"Found {len(swift_files)} Swift files")

    # Generate project file
    print("Generating project.pbxproj...")
    pbxproj_content = generator.generate_project_pbxproj(swift_files)

    # Create .xcodeproj directory structure
    xcodeproj_dir = f"/Users/olorin/Documents/Projects/MathFriends/ios/{project_name}.xcodeproj"
    os.makedirs(xcodeproj_dir, exist_ok=True)

    # Write project.pbxproj
    pbxproj_path = os.path.join(xcodeproj_dir, "project.pbxproj")
    with open(pbxproj_path, 'w') as f:
        f.write(pbxproj_content)

    print(f"✅ Created: {pbxproj_path}")

    # Create xcshareddata directory for schemes
    xcshareddata_dir = os.path.join(xcodeproj_dir, "xcshareddata", "xcschemes")
    os.makedirs(xcshareddata_dir, exist_ok=True)

    # Create scheme file
    scheme_content = f"""<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1500"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "{generator.target_uuid}"
               BuildableName = "{project_name}.app"
               BlueprintName = "{project_name}"
               ReferencedContainer = "container:{project_name}.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES">
      <Testables>
      </Testables>
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "{generator.target_uuid}"
            BuildableName = "{project_name}.app"
            BlueprintName = "{project_name}"
            ReferencedContainer = "container:{project_name}.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "{generator.target_uuid}"
            BuildableName = "{project_name}.app"
            BlueprintName = "{project_name}"
            ReferencedContainer = "container:{project_name}.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
"""

    scheme_path = os.path.join(xcshareddata_dir, f"{project_name}.xcscheme")
    with open(scheme_path, 'w') as f:
        f.write(scheme_content)

    print(f"✅ Created: {scheme_path}")

    # Create Assets.xcassets if it doesn't exist
    assets_dir = os.path.join(source_dir, "Resources", "Assets.xcassets")
    os.makedirs(assets_dir, exist_ok=True)

    # Create Contents.json for Assets
    assets_contents = """{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
"""
    with open(os.path.join(assets_dir, "Contents.json"), 'w') as f:
        f.write(assets_contents)

    # Create AppIcon.appiconset
    appicon_dir = os.path.join(assets_dir, "AppIcon.appiconset")
    os.makedirs(appicon_dir, exist_ok=True)

    appicon_contents = """{
  "images" : [
    {
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
"""
    with open(os.path.join(appicon_dir, "Contents.json"), 'w') as f:
        f.write(appicon_contents)

    # Create AccentColor.colorset
    accentcolor_dir = os.path.join(assets_dir, "AccentColor.colorset")
    os.makedirs(accentcolor_dir, exist_ok=True)

    accentcolor_contents = """{
  "colors" : [
    {
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
"""
    with open(os.path.join(accentcolor_dir, "Contents.json"), 'w') as f:
        f.write(accentcolor_contents)

    print(f"✅ Created Assets.xcassets structure")

    print(f"\n🎉 Xcode project created successfully!")
    print(f"\n📂 Project location: {xcodeproj_dir}")
    print(f"\n🚀 Next steps:")
    print(f"   1. Open project: open {xcodeproj_dir}")
    print(f"   2. Select a simulator (iPhone 15 or later)")
    print(f"   3. Press Cmd+R to build and run")
    print(f"\n📝 Note: You may need to select your Development Team in Xcode's Signing & Capabilities")

if __name__ == "__main__":
    main()
