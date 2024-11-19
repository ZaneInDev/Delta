local Flags = { ["FFlagDebugGraphicsPreferOpenGL"] = "True", ["FFlagDebugGraphicsPreferD3D11FL10"] = "True", ["FFlagGameBasicSettingsFramerateCap5"] = "False", ["DFIntTaskSchedulerTargetFps"] = "5588562", ["FFlagTaskSchedulerLimitTargetFpsTo2402"] = "False", ["DFIntMaxFrameBufferSize"] = "4", ["FIntDebugForceMSAASamples"] = "0", ["DFFlagDebugPerfMode"] = "True", ["FFlagDisablePostFx"] = "True", ["FFlagFixGraphicsQuality"] = "True", ["DFFlagDisableDPIScale"] = "True", ["FFlagHandleAltEnterFullscreenManually"] = "False", ["DFIntCSGLevelOfDetailSwitchingDistance"] = "0", ["DFIntCSGLevelOfDetailSwitchingDistanceL12"] = "0", ["DFIntCSGLevelOfDetailSwitchingDistanceL23"] = "0", ["DFIntCSGLevelOfDetailSwitchingDistanceL34"] = "0", ["DFFlagDebugRenderForceTechnologyVoxel_PlaceFilter"] = "True;2788229376", ["DFFlagDebugPauseVoxelizer_PlaceFilter"] = "True;2788229376", ["DFFlagVoxelizerDisableTerrainSIMD"] = "True", ["DFFlagDebugSkipMeshVoxelizer"] = "True", ["FIntRenderShadowIntensity"] = "0", ["DFIntCullFactorPixelThresholdShadowMapHighQuality"] = "2147483647", ["DFIntCullFactorPixelThresholdShadowMapLowQuality"] = "2147483647", ["FIntRenderLocalLightUpdatesMax"] = "1", ["FIntRenderLocalLightUpdatesMin"] = "1", ["FFlagDebugRenderingSetDeterministic"] = "True", ["FIntTerrainArraySliceSize"] = "4", ["FIntFRMMinGrassDistance"] = "0", ["FIntFRMMaxGrassDistance"] = "0", ["FIntRenderGrassDetailStrands"] = "0" }
local Success, Error = pcall(function()
    for Flag, Value in next, Flags do
        setfflag(Flag, Value)
    end
end)

if Success then 
    print("F-Flags successfully modified.") 
else 
    warn(Error) 
end