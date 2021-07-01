-- ------------------------- Core ------------------------

AddonQuickStart = {}
local self = AddonQuickStart

-- ------------------------- Dev ------------------------

local LuaPath       = GetLuaModsPath()
-- Check if a folder named MashAdmin exists, if so, all paths that leads to your library or addons will have a "Dev" at the end.
-- eg. MashLibDev\, MashProfilesDev\
local DeveloperMode = FolderExists(LuaPath .. [[MashAdmin\]]) or false
local DevPath       = '' -- Keep this empty
if DeveloperMode then DevPath = [[Dev]] end

-- ------------------------- Info ------------------------

self.Info = {
    Author      = "Mash",
    AddonName   = "AddonQuickStart",
    ClassName   = "AddonQuickStart",
    Version     = 1,
    StartDate   = "01-01-2021",
    LastUpdate  = "01-01-2021",
    Description = "AddonQuickStart",
    ChangeLog = {
        [1] = { Version = [[0.0.1]], Description = [[Starting development.]] }
    }
}

-- ------------------------- Paths ------------------------

local LuaPath           = GetLuaModsPath()
self.MinionSettings     = LuaPath                   .. [[ffxivminion\]]
self.ModulePath         = LuaPath                   .. self.Info.ClassName      .. DevPath .. [[\]]
self.LibraryPath        = LuaPath                   .. [[MashLib]]              .. DevPath .. [[\]]
self.ModuleSettingPath  = self.MinionSettings       .. self.Info.ClassName      .. DevPath .. [[\]]
self.LibrarySettingPath = self.MinionSettings       .. [[MashLib]]              .. DevPath .. [[\]]
self.SettingsPath       = self.ModuleSettingPath    .. [[change-this-settings.lua]]

-- ------------------------- Settings ------------------------

self.DefaultSettings = {
    Version = self.Info.Version
}

if FileExists(self.SettingsPath) then
    self.Settings = FileLoad(self.SettingsPath)
else
    FileSave(self.SettingsPath, self.DefaultSettings)
    self.Settings = FileLoad(self.SettingsPath)
end

-- ------------------------- States ------------------------

self.Style          = {}
self.Helpers        = {}
self.Misc           = {}
self.SaveLastCheck  = Now()

-- ------------------------- GUI ------------------------

self.GUI = {
    Open    = false,
    Visible = true,
    OnClick = loadstring(self.Info.ClassName .. [[.GUI.Open = not ]] .. self.Info.ClassName .. [[.GUI.Open]]),
    IsOpen  = loadstring([[return ]] .. self.Info.ClassName .. [[.GUI.Open]]),
    ToolTip = self.Info.Description
}

-- ------------------------- Style ------------------------

self.Style.MainWindow = {
    Size        = { Width = 500, Height = 400 },
    Components  = { MainTabs = GUI_CreateTabs([[Page 1,Page 2, Page 3]]) }
}

-- ------------------------- Log ------------------------

function AddonQuickStart.Log(log)
    local content = "==== [" .. self.Info.AddonName .. "] " .. tostring(log)
    d(content)
end

-- ------------------------- Save ------------------------

function AddonQuickStart.Save(force)
    if FileExists(self.SettingsPath) then
        if (force or MashLib.Helpers.TimeSince(self.SaveLastCheck) > 500) then
            self.SaveLastCheck = Now()
            FileSave(self.SettingsPath, self.Settings)
        end
    end
end

-- ------------------------- Init ------------------------

function AddonQuickStart.Init()

-- ------------------------- Folder Structure ------------------------

    if not FolderExists(self.SettingsPath) then
        FolderCreate(self.SettingsPath)
    end

-- ------------------------- Init Status ------------------------

    AddonQuickStart.Log([[Addon started]])

-- ------------------------- Dropdown Member ------------------------

    local ModuleTable = self.GUI
    ml_gui.ui_mgr:AddMember({
        id      = self.Info.ClassName,
        name    = self.Info.AddonName,
        onClick = function() ModuleTable.OnClick() end,
        tooltip = ModuleTable.ToolTip,
        texture = [[]]
    }, [[FFXIVMINION##MENU_HEADER]])
end

-- ------------------------- Update ------------------------

function AddonQuickStart.Update()
    AddonQuickStart.Save(false)
end

-- ------------------------- Draw ------------------------

function AddonQuickStart.MainWindow(event, tickcount)
    if self.GUI.Open then

-- ------------------------- MainWindow ------------------------

        local flags = (GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoResize)
        GUI:SetNextWindowSize(self.Style.MainWindow.Size.Width, self.Style.MainWindow.Size.Height, GUI.SetCond_Always)
        self.GUI.Visible, self.GUI.Open = GUI:Begin(self.Info.AddonName, self.GUI.Open, flags)

            local TabIndex, TabName = GUI_DrawTabs(self.Style.MainWindow.Components.MainTabs)
            
-- ------------------------- Tab 1 ------------------------

                if TabIndex == 1 then
                    -- Do stuff
                end

-- ------------------------- Tabs 2 ------------------------

                if TabIndex == 2 then
                    -- Do stuff
                end

-- ------------------------- Tabs 3 ------------------------

                if TabIndex == 3 then
                    -- Do stuff
                end

        GUI:End()
    end
end

-- ------------------------- RegisterEventHandler ------------------------

RegisterEventHandler([[Module.Initalize]], AddonQuickStart.Init, [[AddonQuickStart.Init]])
RegisterEventHandler([[Gameloop.Update]], AddonQuickStart.Update, [[AddonQuickStart.Update]])
RegisterEventHandler([[Gameloop.Draw]], AddonQuickStart.MainWindow, [[AddonQuickStart.MainWindow]])
