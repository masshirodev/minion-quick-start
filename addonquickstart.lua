AddonQuickStart = {}
local self = AddonQuickStart

-- Developer Mode
local LuaPath       = GetLuaModsPath()
-- Check if a folder named MashAdmin exists, if so, all paths that leads to your library or addons will have a "Dev" at the end.
-- eg. MashLibDev\, MashProfilesDev\
local DeveloperMode = FolderExists(LuaPath .. [[MashAdmin\]]) or false
local DevPath       = '' -- Keep this empty
if DeveloperMode then DevPath = [[Dev]] end

-- Info
self.Info = {
    Author      = "Mash",
    AddonName   = "AddonQuickStart",
    ClassName   = "AddonQuickStart",
    Version     = "0.0.1",
    StartDate   = "11-01-2021",
    LastUpdate  = "11-01-2021",
    Description = "AddonQuickStart",
    ChangeLog = {
        ["0.0.1"] = "Starting development"
    }
}

local LuaPath           = GetLuaModsPath()
self.MinionSettings     = LuaPath                   .. [[ffxivminion\]]
self.ModulePath         = LuaPath                   .. self.Info.ClassName      .. DevPath .. [[\]]
self.LibraryPath        = LuaPath                   .. [[MashLib]]              .. DevPath .. [[\]]
self.ModuleSettingPath  = self.MinionSettings       .. self.Info.ClassName      .. DevPath .. [[\]]
self.LibrarySettingPath = self.MinionSettings       .. [[MashLib]]              .. DevPath .. [[\]]
self.LogPath            = self.ModulePath           .. [[logs\]]
self.SettingsPath       = self.ModuleSettingPath    .. [[change-this-settings.lua]]

-- Settings
if FileExists(self.SettingsPath) then
    self.Settings = FileLoad(self.SettingsPath)
else
    local DefaultSettings = {
        EnableAddonQuickStart   = true,
        isCharacterLogged       = MashLib.System.CheckLogin(),
        LogToFile               = false,
        DebugLevel              = 3
    }

    FileSave(self.SettingsPath, DefaultSettings)
    self.Settings = FileLoad(self.SettingsPath)
end

-- Modules
self.Style          = { MainWindow = {} }
self.Helpers        = {}
self.Misc           = {}
self.SaveLastCheck  = Now()

-- Params to show your addon in the ffxivminion's dropdown
self.GUI = {
    name = self.Info.AddonName,
    NavName = self.Info.AddonName,
    open = false,
    visible = true,
    drawMode = 1,
    MiniButton = false,
    OnClick = loadstring(self.Info.ClassName .. [[.GUI.open = not ]] .. self.Info.ClassName .. [[.GUI.open]]),
    IsOpen = loadstring([[return ]] .. self.Info.ClassName .. [[.GUI.open]]),
    ToolTip = [[Addon Quick Start]]
}

-- Main Window
self.Style.MainWindow = {
    Title = self.Info.AddonName,
    Position = {
        X = 40,
        Y = 175
    },
    Size = {
        Width = 500,
        Height = 400
    },
    Buttons = {
        BtnPadX = 20,
        BtnPadY  = 20,
    },
    Components = {
        MainTabs = GUI_CreateTabs([[Page 1,Page 2, Page 3]])
    }
}

function AddonQuickStart.Helpers.Log(log, type)
    local type = type or [[string]]

    if type == [[string]] then
        -- Console
        local content = "==== [" .. self.Info.AddonName .. "] " .. tostring(log)
        d(content)

        -- File
        if self.Settings.LogToFile then
            local logFile = io.open(self.LogFile, [[a]])
            logFile:write("[" .. MashLib.Helpers.GetTime('formatted') .. "] " .. content .. "\n")
            logFile:close()
        end
    elseif type == [[block]] then
        d("==== [" .. self.Info.AddonName .. "] Block log start")
        d(log)
        d("==== [" .. self.Info.AddonName .. "] Block log end")
    end
end

function AddonQuickStart.Save(force)
    if FileExists(self.SettingsPath) then
        if (force or MashLib.Helpers.TimeSince(self.SaveLastCheck) > 500) then
            self.SaveLastCheck = Now()
            FileSave(self.SettingsPath, self.Settings)
        end
    end
end

function AddonQuickStart.Init()
    if self.Settings.EnableAddonQuickStart and type(MashLib) == [[table]] then
        -- Creates the folder structure
        if not FolderExists(self.LogPath) then
            FolderCreate(self.LogPath)
        end

        if not FolderExists(self.SettingsPath) then
            FolderCreate(self.SettingsPath)
        end

        self.LogFile = self.LogPath .. MashLib.Helpers.GetTime() .. [[-log.txt]]
        self.Helpers.Log([[Addon started]])

        local ModuleTable = self.GUI
        ml_gui.ui_mgr:AddMember({
            id = self.Info.ClassName,
            name = self.Info.AddonName,
            onClick = function() ModuleTable.OnClick() end,
            tooltip = ModuleTable.ToolTip,
            texture = ""
        }, "FFXIVMINION##MENU_HEADER")
    end
end

function AddonQuickStart.onUpdate()
    if type(MashLib) == [[table]] then
        self.Settings.isCharacterLogged = MashLib.System.CheckLogin()
        AddonQuickStart.Save(false)
        
        if self.Settings.isCharacterLogged then
            -- Something
        end
    end
end

function AddonQuickStart.GUI.drawMainWindow(event, tickcount)
    if self.GUI.open then
        local flags = (GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoResize)
        GUI:SetNextWindowSize(self.Style.MainWindow.Size.Width, self.Style.MainWindow.Size.Height, GUI.SetCond_Always)
        GUI:SetNextWindowPos(self.Style.MainWindow.Position.X, self.Style.MainWindow.Position.Y, GUI.SetCond_Once)
        self.GUI.visible, self.GUI.open = GUI:Begin(tostring(self.Style.MainWindow.Title), self.GUI.open, flags)

            local TabIndex, TabName = GUI_DrawTabs(self.Style.MainWindow.Components.MainTabs)
            
                if TabIndex == 1 then
                    -- Do stuff
                end

                if TabIndex == 2 then
                    -- Do stuff
                end

                if TabIndex == 3 then
                    -- Do stuff
                end

        GUI:End()
    end
end

if self.Settings.EnableAddonQuickStart then
    RegisterEventHandler([[Module.Initalize]], AddonQuickStart.Init, [[AddonQuickStart.Init]])
    RegisterEventHandler([[Gameloop.Update]], AddonQuickStart.onUpdate, [[AddonQuickStart.onUpdate]])
    RegisterEventHandler([[Gameloop.Draw]], AddonQuickStart.GUI.drawMainWindow, [[AddonQuickStart.GUI.drawMainWindow]])
end
