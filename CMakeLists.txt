CMAKE_MINIMUM_REQUIRED(VERSION 2.8.7)
INCLUDE(platform.cmake)

set(recast_public_hdrs
  Recast/Include/Recast.h
)
set(recast_sources
  ${recast_public_hdrs}
  Recast/Include/RecastAlloc.h
  Recast/Include/RecastAssert.h
  Recast/Source/Recast.cpp
  Recast/Source/RecastAlloc.cpp
  Recast/Source/RecastArea.cpp
  Recast/Source/RecastAssert.cpp
  Recast/Source/RecastContour.cpp
  Recast/Source/RecastFilter.cpp
  Recast/Source/RecastLayers.cpp
  Recast/Source/RecastMesh.cpp
  Recast/Source/RecastMeshDetail.cpp
  Recast/Source/RecastRasterization.cpp
  Recast/Source/RecastRegion.cpp
  Detour/Include/DetourAlloc.h
  Detour/Include/DetourAssert.h
  Detour/Include/DetourCommon.h
  Detour/Include/DetourNavMesh.h
  Detour/Include/DetourMath.h
  Detour/Include/DetourNavMeshBuilder.h
  Detour/Include/DetourNavMeshQuery.h
  Detour/Include/DetourNode.h
  Detour/Include/DetourStatus.h
  Detour/Source/DetourAlloc.cpp
  Detour/Source/DetourAssert.cpp
  Detour/Source/DetourCommon.cpp
  Detour/Source/DetourNavMesh.cpp
  Detour/Source/DetourNavMeshBuilder.cpp
  Detour/Source/DetourNavMeshQuery.cpp
  Detour/Source/DetourNode.cpp
  DetourCrowd/Include/DetourCrowd.h
  DetourCrowd/Include/DetourObstacleAvoidance.h
  DetourCrowd/Include/DetourPathQueue.h
  DetourCrowd/Include/DetourLocalBoundary.h
  DetourCrowd/Include/DetourPathCorridor.h
  DetourCrowd/Include/DetourProximityGrid.h
  DetourCrowd/Source/DetourCrowd.cpp
  DetourCrowd/Source/DetourLocalBoundary.cpp
  DetourCrowd/Source/DetourObstacleAvoidance.cpp
  DetourCrowd/Source/DetourPathCorridor.cpp
  DetourCrowd/Source/DetourPathQueue.cpp
  DetourCrowd/Source/DetourProximityGrid.cpp
  DebugUtils/Include/DebugDraw.h
  DebugUtils/Include/DetourDebugDraw.h
  DebugUtils/Include/RecastDebugDraw.h
  DebugUtils/Include/RecastDump.h
  DebugUtils/Source/DebugDraw.cpp
  DebugUtils/Source/DetourDebugDraw.cpp
  DebugUtils/Source/RecastDebugDraw.cpp
  DebugUtils/Source/RecastDump.cpp
  DetourTileCache/Include/DetourTileCache.h
  DetourTileCache/Include/DetourTileCacheBuilder.h
  DetourTileCache/Source/DetourTileCache.cpp
  DetourTileCache/Source/DetourTileCacheBuilder.cpp
)

include_directories(${CMAKE_SOURCE_DIR}/Recast/Include)
include_directories(${CMAKE_SOURCE_DIR}/Detour/Include)
include_directories(${CMAKE_SOURCE_DIR}/DetourCrowd/Include)
include_directories(${CMAKE_SOURCE_DIR}/DebugUtils/Include)
include_directories(${CMAKE_SOURCE_DIR}/DetourTileCache/Include)

SETUP_COMPILER()
ADD_LIBRARY(itsRecast STATIC ${recast_sources})
SETUP_CPP11(itsRecast)

if(APPLE)
  set(lib_dir mac)
elseif(UNIX)
  set(lib_dir linux)
else()
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /D_ITERATOR_DEBUG_LEVEL=1")
  SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /D_ITERATOR_DEBUG_LEVEL=0")
  set(lib_dir win_$<CONFIG>)
  set_target_properties(itsRecast PROPERTIES COMPILE_OPTIONS "/Z7")
endif()

install(TARGETS itsRecast
  LIBRARY       DESTINATION ${lib_dir}
  ARCHIVE       DESTINATION ${lib_dir}
  RUNTIME       DESTINATION ${lib_dir}
  PUBLIC_HEADER DESTINATION include
)
