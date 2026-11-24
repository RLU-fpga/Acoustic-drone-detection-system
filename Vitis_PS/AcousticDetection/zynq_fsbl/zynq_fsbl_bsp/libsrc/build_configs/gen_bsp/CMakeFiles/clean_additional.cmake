# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/Vitis_PS/AcousticDetection/zynq_fsbl/zynq_fsbl_bsp/include/diskio.h"
  "/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/Vitis_PS/AcousticDetection/zynq_fsbl/zynq_fsbl_bsp/include/ff.h"
  "/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/Vitis_PS/AcousticDetection/zynq_fsbl/zynq_fsbl_bsp/include/ffconf.h"
  "/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/Vitis_PS/AcousticDetection/zynq_fsbl/zynq_fsbl_bsp/include/sleep.h"
  "/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/Vitis_PS/AcousticDetection/zynq_fsbl/zynq_fsbl_bsp/include/xilffs.h"
  "/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/Vitis_PS/AcousticDetection/zynq_fsbl/zynq_fsbl_bsp/include/xilffs_config.h"
  "/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/Vitis_PS/AcousticDetection/zynq_fsbl/zynq_fsbl_bsp/include/xilrsa.h"
  "/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/Vitis_PS/AcousticDetection/zynq_fsbl/zynq_fsbl_bsp/include/xiltimer.h"
  "/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/Vitis_PS/AcousticDetection/zynq_fsbl/zynq_fsbl_bsp/include/xtimer_config.h"
  "/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/Vitis_PS/AcousticDetection/zynq_fsbl/zynq_fsbl_bsp/lib/libxilffs.a"
  "/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/Vitis_PS/AcousticDetection/zynq_fsbl/zynq_fsbl_bsp/lib/libxilrsa.a"
  "/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/Vitis_PS/AcousticDetection/zynq_fsbl/zynq_fsbl_bsp/lib/libxiltimer.a"
  )
endif()
