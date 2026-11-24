# 2026-11-24T13:38:26.994992402
import vitis

client = vitis.create_client()
client.set_workspace(path="Vitis_PS")

platform = client.create_platform_component(name = "AcousticDetection",hw_design = "$COMPONENT_LOCATION/../interconnect_wrapper.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",compiler = "gcc")

platform = client.get_component(name="AcousticDetection")
status = platform.build()

comp = client.create_app_component(name="drone_app",platform = "$COMPONENT_LOCATION/../AcousticDetection/export/AcousticDetection/AcousticDetection.xpfm",domain = "standalone_ps7_cortexa9_0")

status = platform.build()

comp = client.get_component(name="drone_app")
comp.build()

