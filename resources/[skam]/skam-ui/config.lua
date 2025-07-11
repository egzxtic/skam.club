Config = {}
Config = {
    debug = true, 
    ShowHud = true,
    Wait = 250,
    proximityModes = {
        { 1.0, 25 },
        { 6.0, 50 },
        { 12.0, 100 }
    },
}

radioConfig = {
    Controls = {
        Activator = { Name = "INPUT_REPLAY_START_STOP_RECORDING_SECONDARY", Key = 289 },
        Secondary = { Name = "INPUT_SPRINT", Key = 21, Enabled = true },
        Toggle = { Name = "INPUT_CONTEXT", Key = 51 },
        Increase = { Name = "INPUT_CELLPHONE_RIGHT", Key = 175, Pressed = false },
        Decrease = { Name = "INPUT_CELLPHONE_LEFT", Key = 174, Pressed = false },
        Input = { Name = "INPUT_FRONTEND_ACCEPT", Key = 201, Pressed = false },
        Broadcast = { Name = "INPUT_CHARACTER_WHEEL", Key = 19 },
        ToggleClicks = { Name = "INPUT_SELECT_WEAPON", Key = 37 }
    },
    Frequency = {
        Private = {},
        Current = 100,
        CurrentIndex = 100,
        Min = 1,
        Max = 1000,
        List = {},
        Access = {},
    },
    Frequencyname = {
        { id = 1, name = "PD #1" },
        { id = 2, name = "Akcja #1" },
        { id = 3, name = "Akcja #2" },
        { id = 4, name = "Napad #1" },
        { id = 5, name = "Napad #2" },
    },
    RestrictedOffset = 0,
    RestrictedFrequencies = {
        ['police'] = { 1,2,3,4,5 },
    },
    AllowRadioWhenClosed = true
}

Config.ChatCommands = {
    ['global'] = {
        receivers = -1,
    },
    ['adminchat'] = {
        receivers = 'admins',
        groups = {
            ['trialsupport'] = true,         
            ['support'] = true,
            ['mod'] = true,
            ['smod'] = true,
            ['admin'] = true,
            ['headadmin'] = true,
            ['zarzad'] = true,
            ['prezeszarzadu'] = true,
            ['eventmanager'] = true,
            ['opiekunadm'] = true,
            ['mediamanagment'] = true,
            ['managment'] = true,
            ['developer'] = true,
            ['txmanager'] = true, 
            ['ceo'] = true,
            ['owner'] = true
        } 
    },
    ['LOOC'] = {
        receivers = 'distance',
    },
}

Config.ChatBadges = {
    ['user'] = {label = 'GRACZ', color = 'rgb(255, 255, 255)'},
    -- ['vip'] = {label = 'VIP', color = 'rgb(229, 198, 44)'},
    ['hounds'] = {label = 'HOUNDS', color = 'rgb(20, 20, 20)'},
    ['revivator'] = {label = 'REVIVATOR', color = 'rgb(100, 150, 200)'},
    ['trialsupport'] = {label = 'TRIAL SUPPORT', color = 'rgb(50, 100, 30)'},
    ['support'] = {label = 'SUPPORT', color = 'rgb(100, 200, 50)'},
    ['mod'] = {label = 'MODERATOR', color = 'rgb(50, 100, 200)'},
    ['smod'] = {label = 'SENIOR MODERATOR', color = 'rgb(4, 32, 158)'},
    ['admin'] = {label = 'ADMIN', color = 'rgb(150, 20, 20)'},
    ['headadmin'] = {label = 'HEAD ADMIN', color = 'rgb(255, 50, 50)'},
    ['zarzad'] = {label = 'ZARZAD', color = 'rgb(135, 153, 174)'},
    ['prezeszarzadu'] = {label = 'PREZES ZARZADU', color = 'rgb(65, 63, 63)'},
    ['eventmanager'] = {label = 'EVENT MANAGER', color = 'rgb(212, 132, 61)'},
    ['opiekunadm'] = {label = 'OPIEKUN ADMINISTRACJI', color = 'rgb(130, 107, 194)'},
    ['mediamanagment'] = {label = 'MEDIA MANAGMENT', color = 'rgb(200, 100, 150)'},
    ['managment'] = {label = 'MANAGMENT', color = 'rgb(76, 173, 208)'},
    ['developer'] = {label = 'DEVELOPER', color = 'rgb(230, 50, 107)'},
    ['txmanager'] = {label = 'TX MANAGER', color = 'rgb(250, 232, 8)'},
    ['ceo'] = {label = 'CEO', color = 'rgb(50, 200, 100)'},
    ['owner'] = {label = 'OWNER', color = 'rgb(10, 10, 10)'},
}