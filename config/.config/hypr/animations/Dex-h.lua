hl.curve("linear",         { type = "bezier", points = { {0.00, 0.00}, {1.00, 1.00} } })
hl.curve("Smooth",         { type = "bezier", points = { {0.25, 0.10}, {0.25, 1.00} } })
hl.curve("Elegant",        { type = "bezier", points = { {0.22, 1.28}, {0.36, 1.00} } })
hl.curve("Apple",          { type = "bezier", points = { {0.34, 1.45}, {0.32, 1.00} } })
hl.curve("Vision",         { type = "bezier", points = { {0.20, 1.38}, {0.32, 1.00} } })
hl.curve("Fluid",          { type = "bezier", points = { {0.18, 1.20}, {0.30, 1.00} } })
hl.curve("Silk",           { type = "bezier", points = { {0.28, 1.12}, {0.40, 1.00} } })
hl.curve("Swift",          { type = "bezier", points = { {0.15, 1.35}, {0.20, 1.00} } })
hl.curve("Pop",            { type = "bezier", points = { {0.25, 1.55}, {0.30, 1.00} } })
hl.curve("AppleOut",       { type = "bezier", points = { {0.55, 0.00}, {0.35, 1.00} } })
hl.curve("SmoothOut",      { type = "bezier", points = { {0.40, 0.00}, {0.20, 1.00} } })
hl.curve("Fade",           { type = "bezier", points = { {0.30, 0.00}, {0.70, 1.00} } })

-- Spring
-- Default springs
hl.curve("Spring",         { type = "spring", mass = 1, stiffness = 82, dampening = 17 })


-- hl.animation({ leaf = "global",          enabled = true,  speed = 10,bezier = "default" })
hl.animation({ leaf = "border",             enabled = true,  speed = 3, bezier = "Smooth" })
hl.animation({ leaf = "windowsMove",        enabled = true,  speed = 3, bezier = "Smooth" })
hl.animation({ leaf = "windowsIn",          enabled = true,  speed = 5, bezier = "Fluid", style = "slide right 75%" })
hl.animation({ leaf = "windowsOut",         enabled = true,  speed = 5, bezier = "Fluid",style =  "slide left 75%" })
hl.animation({ leaf = "fadeIn",             enabled = true,  speed = 3, bezier = "Silk" })
hl.animation({ leaf = "fadeOut",            enabled = true,  speed = 3, bezier = "Silk" })
hl.animation({ leaf = "layersIn",           enabled = true,  speed = 5, bezier = "Smooth"})
hl.animation({ leaf = "layersOut",          enabled = true,  speed = 7, bezier = "Silk" })
hl.animation({ leaf = "fadeLayersIn",       enabled = true,  speed = 7, bezier = "Silk"})
hl.animation({ leaf = "fadeLayersOut",      enabled = true,  speed = 7, bezier = "Silk" })
hl.animation({ leaf = "specialWorkspace",   enabled = true,  speed = 7, bezier = "Fluid", style="slidevert"})
hl.animation({ leaf = "workspacesIn",       enabled = true,  speed = 5, bezier = "Elegant", style = "slidefade 50%" })
hl.animation({ leaf = "workspacesOut",      enabled = true,  speed = 5, bezier = "Elegant", style = "slidefade 50%"  })
hl.animation({ leaf = "zoomFactor",         enabled = true,  speed = 5, bezier = "Smooth" })


