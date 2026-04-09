--[[
    Milenium Library FIXED
    -> Config System Fixed (Save/Load/Auto-Folder)
    -> No more parse errors or missing functions
]]

-- Variables 
local uis = game:GetService("UserInputService") 
local players = game:GetService("Players") 
local ws = game:GetService("Workspace")
local rs = game:GetService("ReplicatedStorage")
local http_service = game:GetService("HttpService")
local gui_service = game:GetService("GuiService")
local lighting = game:GetService("Lighting")
local run = game:GetService("RunService")
local stats = game:GetService("Stats")
local coregui = game:GetService("CoreGui")
local debris = game:GetService("Debris")
local tween_service = game:GetService("TweenService")
local sound_service = game:GetService("SoundService")

local vec2 = Vector2.new
local vec3 = Vector3.new
local dim2 = UDim2.new
local dim = UDim.new 
local rect = Rect.new
local cfr = CFrame.new
local empty_cfr = cfr()
local point_object_space = empty_cfr.PointToObjectSpace
local angle = CFrame.Angles
local dim_offset = UDim2.fromOffset

local color = Color3.new
local rgb = Color3.fromRGB
local hex = Color3.fromHex
local hsv = Color3.fromHSV
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new
local numseq = NumberSequence.new
local numkey = NumberSequenceKeypoint.new

local camera = ws.CurrentCamera
local lp = players.LocalPlayer 
local mouse = lp:GetMouse() 
local gui_offset = gui_service:GetGuiInset().Y

local max = math.max 
local floor = math.floor 
local min = math.min 
local abs = math.abs 
local noise = math.noise
local rad = math.rad 
local random = math.random 
local pow = math.pow 
local sin = math.sin 
local pi = math.pi 
local tan = math.tan 
local atan2 = math.atan2 
local clamp = math.clamp 

local insert = table.insert 
local find = table.find 
local remove = table.remove
local concat = table.concat

-- Library init
getgenv().library = {
    directory = "milenium",
    folders = {
        "/fonts",
        "/configs",
    },
    flags = {},
    config_flags = {},
    connections = {},   
    notifications = {notifs = {}},
    current_open = nil,
    cache = Instance.new("Frame"),
}

-- AUTO FOLDER CREATION FIX
if not isfolder(library.directory) then makefolder(library.directory) end
for _, path in next, library.folders do 
    if not isfolder(library.directory .. path) then makefolder(library.directory .. path) end
end

local themes = {
    preset = {
        accent = rgb(102, 196, 255),
    }, 

    utility = {
        accent = {
            BackgroundColor3 = {}, 	
            TextColor3 = {}, 
            ImageColor3 = {}, 
            ScrollBarImageColor3 = {} 
        },
    }
}

local ICON_SOURCES = {
    lucide = "https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/ui-main/ui-main/Icon/lucideIcons.lua",
    solar = "https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/ui-main/ui-main/Icon/solarIcons.lua",
}

local icon_cache = {
    loaded = false,
    lucide = {},
    solar = {},
}

local keys = {
    [Enum.KeyCode.LeftShift] = "LS",
    [Enum.KeyCode.RightShift] = "RS",
    [Enum.KeyCode.LeftControl] = "LC",
    [Enum.KeyCode.RightControl] = "RC",
    [Enum.KeyCode.Insert] = "INS",
    [Enum.KeyCode.Backspace] = "BS",
    [Enum.KeyCode.Return] = "Ent",
    [Enum.KeyCode.LeftAlt] = "LA",
    [Enum.KeyCode.RightAlt] = "RA",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.Minus] = "-",
    [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.Tilde] = "~",
    [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.RightBracket] = "]",
    [Enum.KeyCode.RightParenthesis] = ")",
    [Enum.KeyCode.LeftParenthesis] = "(",
    [Enum.KeyCode.Semicolon] = ",",
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.BackSlash] = "\\",
    [Enum.KeyCode.Comma] = ",",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Slash] = "/",
    [Enum.KeyCode.Asterisk] = "*",
    [Enum.KeyCode.Plus] = "+",
    [Enum.KeyCode.Backquote] = "`",
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3",
    [Enum.KeyCode.Escape] = "ESC",
    [Enum.KeyCode.Space] = "SPC",
}
    
library.__index = library

local flags = library.flags 
local config_flags = library.config_flags
local notifications = library.notifications 

local fonts = {}; do
    function Register_Font(Name, Weight, Style, Asset)
        if not isfile(Asset.Id) then
            writefile(Asset.Id, Asset.Font)
        end

        if isfile(Name .. ".font") then
            delfile(Name .. ".font")
        end

        local Data = {
            name = Name,
            faces = {
                {
                    name = "Normal",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Asset.Id),
                },
            },
        }

        writefile(Name .. ".font", http_service:JSONEncode(Data))
        return getcustomasset(Name .. ".font");
    end
    
    local Medium = Register_Font("Medium", 200, "Normal", {
        Id = "Medium.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf"),
    })

    local SemiBold = Register_Font("SemiBold", 200, "Normal", {
        Id = "SemiBold.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf"),
    })

    fonts = {
        small = Font.new(Medium, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        font = Font.new(SemiBold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    }
end

-- Library functions 
-- Misc functions
function library:tween(obj, properties, easing_style, time) 
    local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()
    return tween
end

--- Bottom-right resize. Grip parented to `frame`: `inside_corner` = sedikit ke **dalam** pojok (aman dari clip UICorner).
function library:resizify(frame, options)
    options = options or {}
    local min_w = options.min_width or frame.Size.X.Offset
    local min_h = options.min_height or frame.Size.Y.Offset
    local grip_size = options.grip_size or 24
    local inside_corner = options.inside_corner or options.InsideCorner
    local outside_pad = options.outside_pad or 3
    local show_grip = options.show_grip ~= false

    local resizing = false
    local start_mouse
    local start_size

    local function apply_size_from_delta(input_pos)
        local vp = camera.ViewportSize
        local tl = frame.AbsolutePosition
        local dx = input_pos.X - start_mouse.X
        local dy = input_pos.Y - start_mouse.Y
        local sw = start_size.X.Offset + dx
        local sh = start_size.Y.Offset + dy
        sw = clamp(sw, min_w, math.max(min_w, vp.X - tl.X))
        sh = clamp(sh, min_h, math.max(min_h, vp.Y - tl.Y))
        frame.Size = dim2(start_size.X.Scale, sw, start_size.Y.Scale, sh)
    end

    if show_grip then
        local inset = inside_corner and -math.max(4, math.floor(grip_size * 0.22)) or outside_pad
        local grip = library:create("TextButton", {
            Parent = frame;
            Name = "resize_grip";
            AutoButtonColor = false;
            Text = "";
            Size = dim2(0, grip_size, 0, grip_size);
            AnchorPoint = vec2(1, 1);
            Position = dim2(1, inset, 1, inset);
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            ZIndex = 100;
            Selectable = false;
        })

        local grip_bg = library:create("Frame", {
            Parent = grip;
            AnchorPoint = vec2(0.5, 0.5);
            Position = dim2(0.5, 0, 0.5, 0);
            Size = dim2(0, grip_size - 2, 0, grip_size - 2);
            BackgroundColor3 = rgb(28, 28, 34);
            BackgroundTransparency = 0.2;
            BorderSizePixel = 0;
        })
        library:create("UICorner", { Parent = grip_bg; CornerRadius = dim(0, 7) })
        library:create("UIStroke", {
            Parent = grip_bg;
            Color = rgb(48, 48, 58);
            Thickness = 1;
            Transparency = 0.45;
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        })

        library:create("ImageLabel", {
            Parent = grip;
            AnchorPoint = vec2(0.5, 0.5);
            Position = dim2(0.5, 0, 0.5, 0);
            Size = dim2(0, 14, 0, 14);
            BackgroundTransparency = 1;
            Image = library:resolve_icon("lucide:grip") or "";
            ImageColor3 = rgb(145, 145, 158);
            BorderSizePixel = 0;
        })

        frame:GetPropertyChangedSignal("Visible"):Connect(function()
            grip.Visible = frame.Visible
        end)
        grip.Visible = frame.Visible

        grip.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                start_mouse = input.Position
                start_size = frame.Size
            end
        end)

        library:connection(uis.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = false
            end
        end)

        library:connection(uis.InputChanged, function(input)
            if not resizing or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then
                return
            end
            apply_size_from_delta(input.Position)
        end)

        return grip
    end

    -- Legacy: small invisible hitbox inside the frame (bottom-right)
    local hit = Instance.new("TextButton")
    hit.Position = dim2(1, -12, 1, -12)
    hit.BorderColor3 = rgb(0, 0, 0)
    hit.Size = dim2(0, 12, 0, 12)
    hit.BorderSizePixel = 0
    hit.BackgroundColor3 = rgb(255, 255, 255)
    hit.Parent = frame
    hit.BackgroundTransparency = 1
    hit.Text = ""

    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            start_mouse = input.Position
            start_size = frame.Size
        end
    end)

    hit.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)

    library:connection(uis.InputChanged, function(input)
        if not resizing or input.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end
        apply_size_from_delta(input.Position)
    end)
end

function fag(tbl)
    local Size = 0
    for _ in tbl do Size = Size + 1 end
    return Size
end

function library:next_flag()
    local index = fag(library.flags) + 1;
    local str = string.format("flagnumber%s", index)
    return str;
end 

function library:mouse_in_frame(uiobject)
    local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
    local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X
    return (y_cond and x_cond)
end

function library:draggify(frame)
    local dragging = false 
    local start_size = frame.Position
    local start 

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = input.Position
            start_size = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    library:connection(uis.InputChanged, function(input, game_event) 
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local viewport_x = camera.ViewportSize.X
            local viewport_y = camera.ViewportSize.Y

            local current_position = dim2(
                0,
                clamp(
                    start_size.X.Offset + (input.Position.X - start.X),
                    0,
                    viewport_x - frame.Size.X.Offset
                ),
                0,
                math.clamp(
                    start_size.Y.Offset + (input.Position.Y - start.Y),
                    0,
                    viewport_y - frame.Size.Y.Offset
                )
            )

            library:tween(frame, {Position = current_position}, Enum.EasingStyle.Linear, 0.05)
            library:close_element()
        end
    end)
end 

function library:convert(str)
    local values = {}
    for value in string.gmatch(str, "[^,]+") do
        insert(values, tonumber(value))
    end
    if #values == 4 then return unpack(values) else return end
end

function library:convert_enum(enum)
    local enum_parts = {}
    for part in string.gmatch(enum, "[%w_]+") do
        insert(enum_parts, part)
    end
    local enum_table = Enum
    for i = 2, #enum_parts do
        local enum_item = enum_table[enum_parts[i]]
        enum_table = enum_item
    end
    return enum_table
end

function library:round(number, float) 
    local f = float
    if f == nil or f == 0 then
        f = 1
    end
    local multiplier = 1 / f
    return floor(number * multiplier + 0.5) / multiplier
end 

function library:apply_theme(instance, theme, property) 
    insert(themes.utility[theme][property], instance)
end

function library:update_theme(theme, color)
    for _, property in themes.utility[theme] do 
        for m, object in property do 
            if object[_] == themes.preset[theme] then 
                object[_] = color 
            end 
        end 
    end 
    themes.preset[theme] = color 
end 

function library:load_icon_sources()
    if icon_cache.loaded then
        return
    end

    local ok_lucide, lucide_icons = pcall(function()
        return loadstring(game:HttpGet(ICON_SOURCES.lucide))()
    end)

    local ok_solar, solar_icons = pcall(function()
        return loadstring(game:HttpGet(ICON_SOURCES.solar))()
    end)

    icon_cache.lucide = ok_lucide and type(lucide_icons) == "table" and lucide_icons or {}
    icon_cache.solar = ok_solar and type(solar_icons) == "table" and solar_icons or {}
    icon_cache.loaded = true
end

function library:resolve_icon(icon_value)
    if type(icon_value) ~= "string" or icon_value == "" then
        return icon_value
    end

    if icon_value:match("^rbxassetid://") or icon_value:match("^https?://") then
        return icon_value
    end

    if icon_value:match("^%d+$") then
        return "rbxassetid://" .. icon_value
    end

    self:load_icon_sources()

    local prefix, name = icon_value:match("^(%w+):(.+)$")
    if prefix and name then
        if prefix == "lucide" then
            return icon_cache.lucide[name] or icon_value
        elseif prefix == "solar" then
            return icon_cache.solar[name] or icon_value
        end
    end

    return icon_cache.lucide[icon_value] or icon_cache.solar[icon_value] or icon_value
end

function library:connection(signal, callback)
    local connection = signal:Connect(callback)
    insert(library.connections, connection)
    return connection 
end

function library:close_element(new_path) 
    local open_element = library.current_open
    if open_element and new_path ~= open_element then
        open_element.set_visible(false)
        open_element.open = false;
    end 
    if new_path ~= open_element then 
        library.current_open = new_path or nil;
    end
end 

function library:create(instance, options)
    local ins = Instance.new(instance)
    for prop, value in options do
        local ok = pcall(function()
            ins[prop] = value
        end)
        if not ok then
            -- Ignore unsupported properties so the UI can still render across executors/clients.
        end
    end
    return ins
end

function library:unload_menu() 
    if library[ "items" ] then library[ "items" ]:Destroy() end
    if library[ "other" ] then library[ "other" ]:Destroy() end 
    for index, connection in library.connections do 
        connection:Disconnect() 
        connection = nil 
    end
    library = nil 
end 

-- FIXED CONFIG FUNCTIONS
function library:get_config()
    local Config = {}
    for i, v in next, flags do
        if type(v) == "table" and v.key then
            Config[i] = {active = v.active, mode = v.mode, key = tostring(v.key)}
        elseif type(v) == "table" and v.Color and v.Transparency then
            Config[i] = {Transparency = v.Transparency, Color = v.Color:ToHex()}
        else
            Config[i] = v
        end
    end 
    return http_service:JSONEncode(Config)
end

function library:load_config(config_json) 
    local success, config = pcall(function() return http_service:JSONDecode(config_json) end)
    if not success then return end
    
    for i, v in next, config do 
        local setter = config_flags[i]
        if setter then 
            pcall(function()
                if type(v) == "table" and v.Color then
                    setter(hex(v.Color), v.Transparency)
                else
                    setter(v)
                end
            end)
        end 
    end 
end

-- Library element functions
local function window_resolve_rbx_image(s, default_id)
    local def = "rbxassetid://" .. tostring(default_id)
    if type(s) ~= "string" or s == "" then
        return def
    end
    if string.find(s, "^rbxassetid://") or string.find(s, "^https?://") then
        return s
    end
    if string.find(s, "^%d+$") then
        return "rbxassetid://" .. s
    end
    return nil
end

function library:window(properties)
    local vw, vh = camera.ViewportSize.X, camera.ViewportSize.Y
    local is_touch_ui = uis.TouchEnabled and not uis.MouseEnabled
    local default_w = is_touch_ui and floor(vw * 0.92 - 16) or floor(vw * 0.58)
    local default_h = is_touch_ui and floor(vh * 0.62 - gui_offset * 0.5) or floor(vh * 0.56)
    default_w = clamp(default_w, 300, vw - 8)
    default_h = clamp(default_h, 280, vh - 8)
    local sidebar_w = is_touch_ui and 148 or 196
    local content_margin = sidebar_w + 20
    local search_w_ui = is_touch_ui and 200 or 320

    local cfg = { 
        suffix = properties.suffix or properties.Suffix or "tech";
        name = properties.name or properties.Name or "nebula";
        game_name = properties.gameInfo or properties.game_info or properties.GameInfo or "Milenium for Counter-Strike: Global Offensive";
        logo = properties.logo or properties.Logo or "116918679098324";
        toggle_button_image = properties.toggleButtonImage or properties.toggle_ui_image or properties.ToggleUiImage or "113154475025105";
        size = properties.size or properties.Size or dim2(0, default_w, 0, default_h);
        sidebar_w = sidebar_w;
        content_margin = content_margin;
        selected_tab = nil;
        items = {};
    }
    
    library[ "items" ] = library:create( "ScreenGui" , {
        Parent = coregui;
        Name = "\0";
        Enabled = true;
        ZIndexBehavior = Enum.ZIndexBehavior.Global;
        IgnoreGuiInset = true;
    });
    
    library[ "other" ] = library:create( "ScreenGui" , {
        Parent = coregui;
        Name = "\0";
        Enabled = false;
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
        IgnoreGuiInset = true;
    }); 

    local items = cfg.items; do
        items[ "main" ] = library:create( "Frame" , {
            Parent = library[ "items" ];
            Size = cfg.size;
            Name = "\0";
            AnchorPoint = vec2(0.5, 0.5);
            Position = dim2(0.5, 0, 0.5, 0);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(14, 14, 16)
        })
        
        library:create( "UICorner" , { Parent = items[ "main" ]; CornerRadius = dim(0, 10) });
        library:create( "UIStroke" , { Color = rgb(23, 23, 29); Parent = items[ "main" ]; ApplyStrokeMode = Enum.ApplyStrokeMode.Border });

        local toggle_rbx = window_resolve_rbx_image(cfg.toggle_button_image, 113154475025105)
            or "rbxassetid://113154475025105"
        local float_toggle_px = 52
        items[ "open_close_button" ] = library:create( "TextButton" , {
            Parent = library[ "items" ];
            Name = "\0";
            Text = "";
            AutoButtonColor = false;
            AnchorPoint = vec2(0, 0.5);
            Position = dim2(0, 18, 0.5, 0);
            Size = dim2(0, float_toggle_px, 0, float_toggle_px);
            BorderSizePixel = 0;
            BackgroundTransparency = 0.18;
            BackgroundColor3 = rgb(22, 22, 26);
        })
        library:create( "UICorner" , { Parent = items[ "open_close_button" ]; CornerRadius = dim(0.5, 0) })
        library:create( "UIStroke" , { Parent = items[ "open_close_button" ]; Color = rgb(40, 40, 48); Transparency = 0.35 });
        items[ "open_close_button_icon" ] = library:create("ImageLabel", {
            Parent = items[ "open_close_button" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, -12, 1, -12);
            Position = dim2(0.5, 0, 0.5, 0);
            AnchorPoint = vec2(0.5, 0.5);
            Image = toggle_rbx;
            ScaleType = Enum.ScaleType.Fit;
            ImageColor3 = rgb(255, 255, 255);
            BorderSizePixel = 0;
        })
        
        items[ "side_frame" ] = library:create( "Frame" , {
            Parent = items[ "main" ];
            BackgroundTransparency = 1;
            Name = "\0";
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, sidebar_w, 1, -25);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(14, 14, 16)
        });
        
        library:create( "Frame" , {
            AnchorPoint = vec2(1, 0);
            Parent = items[ "side_frame" ];
            Position = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 1, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(21, 21, 23)
        });

        local title_row_h = 72
        
        items[ "button_holder" ] = library:create( "Frame" , {
            Parent = items[ "side_frame" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 0, title_row_h);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 1, -title_row_h);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        }); cfg.button_holder = items[ "button_holder" ];
        
        library:create( "UIListLayout" , { Parent = items[ "button_holder" ]; Padding = dim(0, 5); SortOrder = Enum.SortOrder.LayoutOrder });
        library:create( "UIPadding" , { PaddingTop = dim(0, 16); PaddingBottom = dim(0, 36); Parent = items[ "button_holder" ]; PaddingRight = dim(0, 11); PaddingLeft = dim(0, 10) })

        items[ "title_row" ] = library:create("Frame", {
            Parent = items[ "side_frame" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, title_row_h);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255);
        })

        local sidebar_pad_l, sidebar_pad_r, sidebar_logo_gap = 12, 10, 10
        local sidebar_logo_sz = 38
        local sidebar_title_left = sidebar_pad_l + sidebar_logo_sz + sidebar_logo_gap
        local header_rbx = window_resolve_rbx_image(cfg.logo, 116918679098324)
        local header_img = header_rbx or (library:resolve_icon(cfg.logo) or "")
        local header_is_rbx = header_rbx ~= nil
        items[ "title_logo" ] = library:create("ImageLabel", {
            Parent = items[ "title_row" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(0, sidebar_logo_sz, 0, sidebar_logo_sz);
            Position = dim2(0, sidebar_pad_l, 0.5, 0);
            AnchorPoint = vec2(0, 0.5);
            BorderSizePixel = 0;
            Image = header_img;
            ImageColor3 = header_is_rbx and rgb(255, 255, 255) or themes.preset.accent;
            ScaleType = Enum.ScaleType.Fit;
        })
        if not header_is_rbx then
            library:apply_theme(items[ "title_logo" ], "accent", "ImageColor3")
        end

        items[ "title" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            BorderColor3 = rgb(0, 0, 0);
            Parent = items[ "title_row" ];
            Name = "\0";
            Text = string.format("%s %s", cfg.name, cfg.suffix);
            BackgroundTransparency = 1;
            Position = dim2(0, sidebar_title_left, 0.5, 0);
            AnchorPoint = vec2(0, 0.5);
            Size = dim2(1, -(sidebar_title_left + sidebar_pad_r), 0, 0);
            TextColor3 = rgb(255, 255, 255);
            BorderSizePixel = 0;
            RichText = false;
            TextSize = 26;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextYAlignment = Enum.TextYAlignment.Center;
            TextWrapped = true;
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundColor3 = rgb(255, 255, 255);
        })

        local title_gradient = library:create("UIGradient", {
            Parent = items["title"];
            Color = rgbseq{
                rgbkey(0, rgb(200, 235, 255)),
                rgbkey(0.06, rgb(22, 48, 96)),
                rgbkey(0.12, rgb(205, 238, 255)),
                rgbkey(0.2, rgb(18, 42, 88)),
                rgbkey(0.28, rgb(210, 242, 255)),
                rgbkey(0.36, rgb(20, 46, 92)),
                rgbkey(0.44, rgb(198, 232, 255)),
                rgbkey(0.52, rgb(24, 50, 98)),
                rgbkey(0.6, rgb(205, 238, 255)),
                rgbkey(0.68, rgb(18, 44, 90)),
                rgbkey(0.76, rgb(200, 235, 255)),
                rgbkey(0.84, rgb(22, 48, 96)),
                rgbkey(0.92, rgb(208, 240, 255)),
                rgbkey(1, rgb(200, 235, 255))
            };
            Rotation = 12;
            Offset = vec2(0, 0);
        })

        library:connection(run.RenderStepped, function()
            if not title_gradient or not title_gradient.Parent then
                return
            end
            local t = tick()
            title_gradient.Offset = vec2(math.sin(t * 0.35) * 1.6 + math.sin(t * 0.11) * 0.25, math.cos(t * 0.19) * 0.08)
        end)
        
        -- Bar atas: judul + subtitle + sub-tab + search (lapang); search lebih sempit di touch
        local search_w, search_h = search_w_ui, 40
        local header_left_pad, header_gap, search_right_mar = 14, 18, is_touch_ui and 12 or 20
        local header_reserve = header_left_pad + header_gap + search_w + search_right_mar
        local top_bar_h = 78
        local content_bottom_pad = 10
        local content_height_inset = 25 + top_bar_h + content_bottom_pad
        items[ "multi_holder" ] = library:create( "Frame" , {
            Parent = items[ "main" ];
            Name = "\0";
            Visible = true;
            BackgroundTransparency = 1;
            Position = dim2(0, sidebar_w, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -sidebar_w, 0, top_bar_h);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255);
            ZIndex = 3;
        }); cfg.multi_holder = items[ "multi_holder" ];

        items[ "page_header_left" ] = library:create("Frame", {
            Parent = items[ "multi_holder" ];
            Name = "\0";
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = dim2(0, header_left_pad, 0, 8);
            Size = dim2(1, -header_reserve, 1, -16);
            BackgroundColor3 = rgb(255, 255, 255);
        })
        library:create("UIListLayout", {
            Parent = items[ "page_header_left" ];
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Padding = dim(0, 2);
            HorizontalAlignment = Enum.HorizontalAlignment.Left;
            VerticalAlignment = Enum.VerticalAlignment.Top;
        })

        items[ "main_page_title" ] = library:create("TextLabel", {
            Parent = items[ "page_header_left" ];
            Name = "\0";
            BackgroundTransparency = 1;
            FontFace = fonts.font;
            Text = "";
            TextColor3 = themes.preset.accent;
            TextSize = 20;
            TextXAlignment = Enum.TextXAlignment.Left;
            AutomaticSize = Enum.AutomaticSize.XY;
            Size = dim2(0, 0, 0, 0);
            BorderSizePixel = 0;
        })
        library:apply_theme(items[ "main_page_title" ], "accent", "TextColor3")

        items[ "main_page_subtitle" ] = library:create("TextLabel", {
            Parent = items[ "page_header_left" ];
            Name = "\0";
            BackgroundTransparency = 1;
            FontFace = fonts.small;
            Text = "";
            TextColor3 = rgb(120, 120, 130);
            TextSize = 13;
            TextXAlignment = Enum.TextXAlignment.Left;
            AutomaticSize = Enum.AutomaticSize.XY;
            Size = dim2(1, -4, 0, 0);
            BorderSizePixel = 0;
        })

        items[ "tabs_strip_host" ] = library:create("Frame", {
            Parent = items[ "page_header_left" ];
            Name = "\0";
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Size = dim2(1, 0, 0, 30);
            ClipsDescendants = true;
            BackgroundColor3 = rgb(255, 255, 255);
        })

        items[ "search_holder" ] = library:create("Frame", {
            Parent = items[ "multi_holder" ];
            Name = "\0";
            AnchorPoint = vec2(1, 0.5);
            Position = dim2(1, -search_right_mar, 0.5, 0);
            Size = dim2(0, search_w, 0, search_h);
            BackgroundColor3 = rgb(20, 20, 24);
            BorderSizePixel = 0;
        })
        library:create("UICorner", { Parent = items[ "search_holder" ]; CornerRadius = dim(0, math.floor(search_h / 2)) })
        library:create("UIStroke", {
            Parent = items[ "search_holder" ];
            Color = rgb(48, 48, 56);
            Thickness = 1;
            Transparency = 0.35;
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        })

        library:create("ImageLabel", {
            Parent = items[ "search_holder" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(0, 18, 0, 18);
            Position = dim2(0, 14, 0.5, 0);
            AnchorPoint = vec2(0, 0.5);
            Image = library:resolve_icon("lucide:search") or "";
            ImageColor3 = rgb(125, 125, 135);
            BorderSizePixel = 0;
        })

        items[ "window_search" ] = library:create("TextBox", {
            Parent = items[ "search_holder" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, -54, 1, -12);
            Position = dim2(0, 42, 0, 6);
            BorderSizePixel = 0;
            Text = "";
            PlaceholderText = "Search sidebar & tabs…";
            PlaceholderColor3 = rgb(105, 105, 115);
            TextColor3 = rgb(210, 210, 218);
            FontFace = fonts.small;
            TextSize = 14;
            TextXAlignment = Enum.TextXAlignment.Left;
            ClearTextOnFocus = false;
        })

        local function ui_text_for_search(inst)
            if inst:IsA("TextLabel") then
                return inst.Text or ""
            end
            if inst:IsA("TextButton") then
                for _, c in ipairs(inst:GetChildren()) do
                    if c:IsA("TextLabel") and c.Text ~= "" then
                        return c.Text
                    end
                end
            end
            return ""
        end

        function cfg.apply_search_filter()
            local box = items[ "window_search" ]
            if not box then
                return
            end
            local q = string.lower(string.gsub(box.Text or "", "^%s+", ""))
            local function matches(s)
                if q == "" then
                    return true
                end
                if type(s) ~= "string" or s == "" then
                    return false
                end
                return string.find(string.lower(s), q, 1, true) ~= nil
            end
            if items[ "button_holder" ] then
                for _, ch in ipairs(items[ "button_holder" ]:GetChildren()) do
                    if ch:IsA("TextButton") or ch:IsA("TextLabel") then
                        ch.Visible = matches(ui_text_for_search(ch))
                    end
                end
            end
            local st = cfg.selected_tab
            if st and st[ 5 ] and st[ 5 ].Parent then
                for _, ch in ipairs(st[ 5 ]:GetChildren()) do
                    if ch:IsA("TextButton") then
                        ch.Visible = matches(ui_text_for_search(ch))
                    end
                end
            end
        end

        items[ "window_search" ]:GetPropertyChangedSignal("Text"):Connect(function()
            pcall(cfg.apply_search_filter)
        end)
        items[ "window_search" ].FocusLost:Connect(function()
            pcall(cfg.apply_search_filter)
        end)
        
        library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = items[ "multi_holder" ];
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(21, 21, 23)
        });
        
        items[ "shadow" ] = library:create( "ImageLabel" , {
            ImageColor3 = rgb(0, 0, 0);
            ScaleType = Enum.ScaleType.Slice;
            Parent = items[ "main" ];
            BorderColor3 = rgb(0, 0, 0);
            Name = "\0";
            BackgroundColor3 = rgb(255, 255, 255);
            Size = dim2(1, 75, 1, 75);
            AnchorPoint = vec2(0.5, 0.5);
            Image = "rbxassetid://112971167999062";
            BackgroundTransparency = 1;
            Position = dim2(0.5, 0, 0.5, 0);
            SliceScale = 0.75;
            ZIndex = -100;
            BorderSizePixel = 0;
            SliceCenter = rect(vec2(112, 112), vec2(147, 147))
        });
        
        items[ "global_fade" ] = library:create( "Frame" , {
            Parent = items[ "main" ];
            Name = "\0";
            Active = false;
            Selectable = false;
            BackgroundTransparency = 1;
            Position = dim2(0, sidebar_w, 0, top_bar_h);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -content_margin, 1, -content_height_inset);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(14, 14, 16);
            ZIndex = 0;
        });                

        library:create( "UICorner" , { Parent = items[ "shadow" ]; CornerRadius = dim(0, 5) });
        
        items[ "info" ] = library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = items[ "main" ];
            Name = "\0";
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 25);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(23, 23, 25)
        });
        
        library:create( "UICorner" , { Parent = items[ "info" ]; CornerRadius = dim(0, 10) });
        
        items[ "grey_fill" ] = library:create( "Frame" , {
            Name = "\0";
            Parent = items[ "info" ];
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 6);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(23, 23, 25)
        });
        
        items[ "game" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            Parent = items[ "info" ];
            TextColor3 = rgb(72, 72, 73);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.game_name;
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            AnchorPoint = vec2(0, 0.5);
            Position = dim2(0, 10, 0.5, -1);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        }); 
        
        items[ "other_info" ] = library:create( "TextLabel" , {
            Parent = items[ "info" ];
            RichText = true;
            Name = "\0";
            TextColor3 = themes.preset.accent;
            BorderColor3 = rgb(0, 0, 0);
            Text = '<font color="rgb(72, 72, 73)">32 days left, </font>' .. cfg.name .. cfg.suffix;
            Size = dim2(1, 0, 0, 0);
            Position = dim2(0, -10, 0.5, -1);
            AnchorPoint = vec2(0, 0.5);
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Right;
            AutomaticSize = Enum.AutomaticSize.XY;
            FontFace = fonts.font;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        }); library:apply_theme(items[ "other_info" ], "accent", "TextColor3");

        cfg.content_height_inset = content_height_inset
        cfg.top_bar_h = top_bar_h
    end 

    do -- Other
        library:draggify(items[ "main" ])
        local min_rw = math.max(260, floor(cfg.size.X.Offset * 0.42))
        local min_rh = math.max(220, floor(cfg.size.Y.Offset * 0.42))
        items[ "resize_grip" ] = library:resizify(items[ "main" ], {
            min_width = min_rw;
            min_height = min_rh;
            grip_size = 26;
            inside_corner = true;
        })
    end 

    items["open_close_button"].MouseButton1Click:Connect(function()
        items["main"].Visible = not items["main"].Visible
        local ico = items["open_close_button_icon"]
        if ico then
            ico.ImageTransparency = items["main"].Visible and 0 or 0.35
        end
    end)

    function cfg.toggle_menu(bool) 
        library[ "items" ].Enabled = bool
    end 
        
    return setmetatable(cfg, library)
end 

function library:tab(properties)
    local win_sw = self.sidebar_w or 196
    local win_cm = self.content_margin or (win_sw + 20)
    local cfg = {
        name = properties.name or properties.Name or "visuals"; 
        icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6034767608";
        tabs = properties.tabs or properties.Tabs or {"Main", "Misc.", "Settings"};
        default_page_subtitle = properties.subtitle or properties.Subtitle or "";
        page_subtitles = properties.pageSubtitles or properties.page_subtitles or {};
        hide_top_tabs = properties.hideTopTabs or properties.HideTopTabs or false;
        pages = {}; 
        current_multi = nil; 
        items = {};
        sidebar_w = win_sw;
        content_margin = win_cm;
    } 

    local items = cfg.items; do 
        local hinset = self.content_height_inset or (25 + 78 + 10)
        local top_y = self.top_bar_h or 78
        items[ "tab_holder" ] = library:create( "Frame" , {
            Parent = library.cache;
            Name = "\0";
            Visible = false;
            BackgroundTransparency = 1;
            Position = dim2(0, win_sw, 0, top_y);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -win_cm, 1, -hinset);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255);
            ZIndex = 2;
            ClipsDescendants = true;
        });
        
        items[ "button" ] = library:create( "TextButton" , {
            FontFace = fonts.font;
            TextColor3 = rgb(255, 255, 255);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "button_holder" ];
            AutoButtonColor = false;
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(1, 0, 0, 35);
            BorderSizePixel = 0;
            TextSize = 16;
            BackgroundColor3 = rgb(29, 29, 29)
        });
        
        items[ "icon" ] = library:create( "ImageLabel" , {
            ImageColor3 = rgb(72, 72, 73);
            BorderColor3 = rgb(0, 0, 0);
            Parent = items[ "button" ];
            AnchorPoint = vec2(0, 0.5);
            Image = library:resolve_icon(cfg.icon) or "http://www.roblox.com/asset/?id=6034767608";
            BackgroundTransparency = 1;
            Position = dim2(0, 10, 0.5, 0);
            Name = "\0";
            Size = dim2(0, 22, 0, 22);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        }); library:apply_theme(items[ "icon" ], "accent", "ImageColor3");
        
        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = rgb(108, 108, 114);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "button" ];
            Name = "\0";
            Size = dim2(0, 0, 1, 0);
            Position = dim2(0, 40, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.X;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIPadding" , { Parent = items[ "name" ]; PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });
        library:create( "UICorner" , { Parent = items[ "button" ]; CornerRadius = dim(0, 999) });
        library:create( "UIStroke" , { Color = rgb(23, 23, 29); Parent = items[ "button" ]; Enabled = true; Transparency = 0.45; ApplyStrokeMode = Enum.ApplyStrokeMode.Border });

        items[ "menu_dropdown_holder" ] = library:create( "Frame" , {
            Parent = library.cache;
            BackgroundTransparency = 1;
            Name = "\0";
            Visible = false;
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        library:create( "UIListLayout" , {
            Parent = items[ "menu_dropdown_holder" ];
            Padding = dim(0, 14);
            SortOrder = Enum.SortOrder.LayoutOrder;
            FillDirection = Enum.FillDirection.Horizontal;
            VerticalAlignment = Enum.VerticalAlignment.Center;
        });
        library:create( "UIPadding" , { PaddingTop = dim(0, 6); PaddingBottom = dim(0, 6); Parent = items[ "menu_dropdown_holder" ]; PaddingRight = dim(0, 4); PaddingLeft = dim(0, 0) });

        for _, page_name in cfg.tabs do
            local data = {items = {}, page_name = page_name} 
            local multi_items = data.items; do 
                multi_items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    AutoButtonColor = false;
                    Text = "";
                    Parent = items[ "menu_dropdown_holder" ];
                    Name = "\0";
                    Size = dim2(0, 0, 0, 34);
                    BackgroundTransparency = 1;
                    ClipsDescendants = false;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 15;
                    BackgroundColor3 = rgb(25, 25, 29)
                });

                multi_items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(118, 118, 128);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = page_name;
                    Parent = multi_items[ "button" ];
                    Name = "\0";
                    Size = dim2(0, 0, 1, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 15;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIPadding" , { Parent = multi_items[ "name" ]; PaddingRight = dim(0, 2); PaddingLeft = dim(0, 2) });

                multi_items[ "accent" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    AnchorPoint = vec2(0.5, 1);
                    Parent = multi_items[ "button" ];
                    BackgroundTransparency = 1;
                    Position = dim2(0.5, 0, 1, 1);
                    Name = "\0";
                    Size = dim2(1, -4, 0, 3);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                }); library:apply_theme(multi_items[ "accent" ], "accent", "BackgroundColor3");

                library:create( "UICorner" , { Parent = multi_items[ "accent" ]; CornerRadius = dim(0, 2) });
                library:create( "UIPadding" , { Parent = multi_items[ "button" ]; PaddingRight = dim(0, 6); PaddingLeft = dim(0, 6) });

                multi_items[ "tab" ] = library:create( "Frame" , {
                    Parent = library.cache;
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    Visible = false;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , { FillDirection = Enum.FillDirection.Vertical; HorizontalFlex = Enum.UIFlexAlignment.Fill; Parent = multi_items[ "tab" ]; Padding = dim(0, 0); SortOrder = Enum.SortOrder.LayoutOrder; VerticalFlex = Enum.UIFlexAlignment.Fill });
                library:create( "UIPadding" , { PaddingTop = dim(0, 6); PaddingBottom = dim(0, 8); Parent = multi_items[ "tab" ]; PaddingRight = dim(0, 12); PaddingLeft = dim(0, 12) });
            end

            data.text = multi_items[ "name" ]
            data.accent = multi_items[ "accent" ]
            data.button = multi_items[ "button" ]
            data.page = multi_items[ "tab" ]
            data.parent = setmetatable(data, library):sub_tab({}).items[ "tab_parent" ]

            function data.open_page()
                local page = cfg.current_multi; 

                if page and page ~= data then 
                    self.items[ "global_fade" ].BackgroundTransparency = 0
                    library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                    page.page.Size = dim2(1, 0, 1, 0)
                end

                if page then
                    library:tween(page.text, {TextColor3 = rgb(118, 118, 128)})
                    library:tween(page.accent, {BackgroundTransparency = 1})
                    page.page.Visible = false
                    page.page.Parent = library[ "cache" ] 
                end 

                library:tween(data.text, {TextColor3 = rgb(255, 255, 255)})
                library:tween(data.accent, {BackgroundTransparency = 0})
                library:tween(data.page, {Size = dim2(1, 0, 1, 0)}, Enum.EasingStyle.Quad, 0.4)

                data.page.Visible = true
                data.page.Parent = items["tab_holder"]
                cfg.current_multi = data
                if self.items[ "main_page_title" ] then
                    self.items[ "main_page_title" ].Text = data.page_name
                end
                if self.items[ "main_page_subtitle" ] then
                    local sub = cfg.page_subtitles[ data.page_name ] or cfg.default_page_subtitle or ""
                    self.items[ "main_page_subtitle" ].Text = sub
                    self.items[ "main_page_subtitle" ].Visible = sub ~= ""
                end
                library:close_element()
            end

            multi_items[ "button" ].MouseEnter:Connect(function()
                if cfg.current_multi ~= data then
                    library:tween(multi_items["name"], {TextColor3 = rgb(200, 200, 208)}, Enum.EasingStyle.Quad, 0.12)
                end
            end)

            multi_items[ "button" ].MouseLeave:Connect(function()
                if cfg.current_multi ~= data then
                    library:tween(multi_items["name"], {TextColor3 = rgb(118, 118, 128)}, Enum.EasingStyle.Quad, 0.12)
                end
            end)

            multi_items[ "button" ].MouseButton1Down:Connect(function() data.open_page() end)
            cfg.pages[#cfg.pages + 1] = setmetatable(data, library)
        end 
        cfg.pages[1].open_page()
    end 

    function cfg.open_tab() 
        local hinset = self.content_height_inset or (25 + 78 + 10)
        local selected_tab = self.selected_tab
        if selected_tab then 
            if selected_tab[ 5 ] then
                selected_tab[ 5 ].Visible = false
                selected_tab[ 5 ].Parent = library[ "cache" ]
            end
            if selected_tab[ 4 ] and selected_tab[ 4 ] ~= items[ "tab_holder" ] then 
                self.items[ "global_fade" ].BackgroundTransparency = 0
                library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                selected_tab[ 4 ].Size = dim2(1, -cfg.content_margin, 1, -hinset)
            end
            if selected_tab[ 1 ] then library:tween(selected_tab[ 1 ], {BackgroundTransparency = 1, BackgroundColor3 = rgb(29, 29, 29)}) end
            if selected_tab[ 2 ] then library:tween(selected_tab[ 2 ], {ImageColor3 = rgb(108, 108, 114)}) end
            if selected_tab[ 3 ] then library:tween(selected_tab[ 3 ], {TextColor3 = rgb(108, 108, 114)}) end

            if selected_tab[ 4 ] then
                selected_tab[ 4 ].Visible = false
                selected_tab[ 4 ].Parent = library[ "cache" ]
            end
        end

        library:tween(items[ "button" ], {BackgroundTransparency = 0, BackgroundColor3 = themes.preset.accent})
        library:tween(items[ "icon" ], {ImageColor3 = rgb(255, 255, 255)})
        library:tween(items[ "name" ], {TextColor3 = rgb(255, 255, 255)})
        library:tween(items[ "tab_holder" ], {Size = dim2(1, -cfg.content_margin, 1, -hinset)}, Enum.EasingStyle.Quad, 0.4)
        
        items[ "tab_holder" ].Visible = true 
        items[ "tab_holder" ].Parent = self.items[ "main" ]

        local strip_host = self.items[ "tabs_strip_host" ]
        if strip_host then
            items[ "menu_dropdown_holder" ].Parent = strip_host
            items[ "menu_dropdown_holder" ].Size = dim2(1, 0, 1, 0)
            items[ "menu_dropdown_holder" ].Position = dim2(0, 0, 0, 0)
            items[ "menu_dropdown_holder" ].Visible = not cfg.hide_top_tabs
            strip_host.Visible = not cfg.hide_top_tabs
        else
            items[ "menu_dropdown_holder" ].Parent = self.items[ "multi_holder" ]
            items[ "menu_dropdown_holder" ].Size = dim2(1, 0, 1, 0)
            items[ "menu_dropdown_holder" ].Position = dim2(0, 0, 0, 0)
            items[ "menu_dropdown_holder" ].Visible = not cfg.hide_top_tabs
        end

        self.selected_tab = {
            items[ "button" ];
            items[ "icon" ];
            items[ "name" ];
            items[ "tab_holder" ];
            items[ "menu_dropdown_holder" ];
        }
        if self.apply_search_filter then
            task.defer(self.apply_search_filter)
        end
        library:close_element()
    end

    items[ "button" ].MouseEnter:Connect(function()
        if not self.selected_tab or self.selected_tab[1] ~= items["button"] then
            library:tween(items["button"], {BackgroundTransparency = 0.92, BackgroundColor3 = rgb(40, 40, 44)}, Enum.EasingStyle.Quad, 0.15)
            library:tween(items["name"], {TextColor3 = rgb(200, 200, 208)}, Enum.EasingStyle.Quad, 0.15)
            library:tween(items["icon"], {ImageColor3 = rgb(200, 200, 208)}, Enum.EasingStyle.Quad, 0.15)
        end
    end)

    items[ "button" ].MouseLeave:Connect(function()
        if not self.selected_tab or self.selected_tab[1] ~= items["button"] then
            library:tween(items["button"], {BackgroundTransparency = 1, BackgroundColor3 = rgb(29, 29, 29)}, Enum.EasingStyle.Quad, 0.15)
            library:tween(items["name"], {TextColor3 = rgb(108, 108, 114)}, Enum.EasingStyle.Quad, 0.15)
            library:tween(items["icon"], {ImageColor3 = rgb(108, 108, 114)}, Enum.EasingStyle.Quad, 0.15)
        end
    end)

    items[ "button" ].MouseButton1Down:Connect(function() cfg.open_tab() end)
    if not self.selected_tab then cfg.open_tab(true) end

    return unpack(cfg.pages)
end

function library:seperator(properties)
    local cfg = {items = {}, name = properties.Name or properties.name or "General"}
    local items = cfg.items do 
        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = rgb(72, 72, 73);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = self.items[ "button_holder" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            Position = dim2(0, 40, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0; 
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        library:create( "UIPadding" , { Parent = items[ "name" ]; PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });                
    end;    
    return setmetatable(cfg, library)
end 

function library:column(properties) 
    local cfg = {items = {}, size = properties.size or 1}
    local items = cfg.items; do     
        items[ "column" ] = library:create( "Frame" , {
            Parent = self[ "parent" ] or self.items["tab_parent"];
            BackgroundTransparency = 1;
            Name = "\0";
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(cfg.size, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        local col_pad_x = camera.ViewportSize.X < 540 and 6 or 0
        library:create( "UIPadding" , { PaddingBottom = dim(0, 10); PaddingLeft = dim(0, col_pad_x); PaddingRight = dim(0, col_pad_x); Parent = items[ "column" ] });
        library:create( "UIListLayout" , { Parent = items[ "column" ]; HorizontalFlex = Enum.UIFlexAlignment.Fill; Padding = dim(0, 10); FillDirection = Enum.FillDirection.Vertical; SortOrder = Enum.SortOrder.LayoutOrder });
    end 
    return setmetatable(cfg, library)
end 

function library:sub_tab(properties) 
    local cfg = {items = {}, order = properties.order or 0; size = properties.size or 1}
    local items = cfg.items; do 
        items[ "tab_parent" ] = library:create( "Frame" , {
            Parent = self.items[ "tab" ];
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(1, 0, cfg.size, 0);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            Visible = true;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        local sub_gap = camera.ViewportSize.X < 540 and 4 or 7
        library:create( "UIListLayout" , { FillDirection = Enum.FillDirection.Horizontal; HorizontalFlex = Enum.UIFlexAlignment.Fill; VerticalFlex = Enum.UIFlexAlignment.Fill; Parent = items[ "tab_parent" ]; Padding = dim(0, sub_gap); SortOrder = Enum.SortOrder.LayoutOrder; });
    end
    return setmetatable(cfg, library)
end 

function library:section(properties)
    local cfg = {
        name = properties.name or properties.Name or "section"; 
        side = properties.side or properties.Side or "left";
        default = properties.default or properties.Default or false;
        size = properties.size or properties.Size or self.size or 0.5; 
        icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6022668898";
        fading_toggle = properties.fading or properties.Fading or false;
        items = {};
    };
    
    local items = cfg.items; do 
        items[ "outline" ] = library:create( "Frame" , {
            Name = "\0";
            Parent = self.items[ "column" ];
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, cfg.size, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(25, 25, 29)
        });

        library:create( "UICorner" , { Parent = items[ "outline" ]; CornerRadius = dim(0, 7) });
        
        items[ "inline" ] = library:create( "Frame" , {
            Parent = items[ "outline" ];
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(22, 22, 24)
        });
        
        library:create( "UICorner" , { Parent = items[ "inline" ]; CornerRadius = dim(0, 7) });
        
        items[ "scrolling" ] = library:create( "ScrollingFrame" , {
            ScrollBarImageColor3 = rgb(44, 44, 46);
            Active = true;
            AutomaticCanvasSize = Enum.AutomaticSize.Y;
            ScrollBarThickness = 2;
            Parent = items[ "inline" ];
            Name = "\0";
            Size = dim2(1, 0, 1, -40);
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 0, 35);
            BackgroundColor3 = rgb(255, 255, 255);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            CanvasSize = dim2(0, 0, 0, 0)
        });
        
        items[ "elements" ] = library:create( "Frame" , {
            BorderColor3 = rgb(0, 0, 0);
            Parent = items[ "scrolling" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 10, 0, 10);
            Size = dim2(1, -20, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIListLayout" , { Parent = items[ "elements" ]; Padding = dim(0, 10); SortOrder = Enum.SortOrder.LayoutOrder });
        library:create( "UIPadding" , { PaddingBottom = dim(0, 15); Parent = items[ "elements" ] });
        
        items[ "button" ] = library:create( "TextButton" , {
            FontFace = fonts.font;
            TextColor3 = rgb(255, 255, 255);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            AutoButtonColor = false;
            Parent = items[ "outline" ];
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            Size = dim2(1, -2, 0, 35);
            BorderSizePixel = 0;
            TextSize = 16;
            BackgroundColor3 = rgb(19, 19, 21)
        });
        
        library:create( "UIStroke" , { Color = rgb(23, 23, 29); Parent = items[ "button" ]; Enabled = false; ApplyStrokeMode = Enum.ApplyStrokeMode.Border });
        library:create( "UICorner" , { Parent = items[ "button" ]; CornerRadius = dim(0, 7) });
        
        items[ "Icon" ] = library:create( "ImageLabel" , {
            ImageColor3 = themes.preset.accent;
            BorderColor3 = rgb(0, 0, 0);
            Parent = items[ "button" ];
            AnchorPoint = vec2(0, 0.5);
            Image = library:resolve_icon(cfg.icon) or cfg.icon;
            BackgroundTransparency = 1;
            Position = dim2(0, 10, 0.5, 0);
            Name = "\0";
            Size = dim2(0, 22, 0, 22);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        }); library:apply_theme(items[ "Icon" ], "accent", "ImageColor3");
        
        items[ "section_title" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = rgb(255, 255, 255);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "button" ];
            Name = "\0";
            Size = dim2(0, 0, 1, 0);
            Position = dim2(0, 40, 0, -1);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.X;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = items[ "button" ];
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(36, 36, 37)
        });
        
        if cfg.fading_toggle then 
            items[ "toggle" ] = library:create( "TextButton" , {
                FontFace = fonts.small;
                TextColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                AutoButtonColor = false;
                Text = "";
                AnchorPoint = vec2(1, 0.5);
                Parent = items[ "button" ];
                Name = "\0";
                Position = dim2(1, -9, 0.5, 0);
                Size = dim2(0, 36, 0, 18);
                BorderSizePixel = 0;
                TextSize = 14;
                BackgroundColor3 = rgb(58, 58, 62)
            });  library:apply_theme(items[ "toggle" ], "accent", "BackgroundColor3");
            
            library:create( "UICorner" , { Parent = items[ "toggle" ]; CornerRadius = dim(0, 999) });
            
            items[ "toggle_outline" ] = library:create( "Frame" , {
                Parent = items[ "toggle" ];
                Size = dim2(1, -2, 1, -2);
                Name = "\0";
                BorderMode = Enum.BorderMode.Inset;
                BorderColor3 = rgb(0, 0, 0);
                Position = dim2(0, 1, 0, 1);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(50, 50, 50)
            });  library:apply_theme(items[ "toggle_outline" ], "accent", "BackgroundColor3");
            
            library:create( "UICorner" , { Parent = items[ "toggle_outline" ]; CornerRadius = dim(0, 999) });
            library:create( "UIGradient" , { Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))}; Parent = items[ "toggle_outline" ] });
            
            items[ "toggle_circle" ] = library:create( "Frame" , {
                Parent = items[ "toggle_outline" ];
                Name = "\0";
                Position = dim2(0, 2, 0, 2);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 12, 0, 12);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(86, 86, 88)
            });
            
            library:create( "UICorner" , { Parent = items[ "toggle_circle" ]; CornerRadius = dim(0, 999) });
            library:create( "UICorner" , { Parent = items[ "outline" ]; CornerRadius = dim(0, 7) });
        
            items[ "fade" ] = library:create( "Frame" , {
                Parent = items[ "outline" ];
                BackgroundTransparency = 0.800000011920929;
                Name = "\0";
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 0, 1, 0);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(0, 0, 0)
            });
            
            library:create( "UICorner" , { Parent = items[ "fade" ]; CornerRadius = dim(0, 7) });
        end 
    end;

    if cfg.fading_toggle then
        items[ "button" ].MouseButton1Click:Connect(function()
            cfg.default = not cfg.default 
            cfg.toggle_section(cfg.default) 
        end)

        function cfg.toggle_section(bool)
            library:tween(items[ "toggle" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
            library:tween(items[ "toggle_outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
            library:tween(items[ "toggle_circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
            library:tween(items[ "fade" ], {BackgroundTransparency = bool and 1 or 0.8}, Enum.EasingStyle.Quad)
        end 
    end 

    return setmetatable(cfg, library)
end  

function library:toggle(options) 
    local rand = math.random(1, 2) 
    local cfg = {
        enabled = options.enabled or nil,
        name = options.name or "Toggle",
        info = options.info or nil,
        flag = options.flag or library:next_flag(),
        type = options.type and string.lower(options.type) or rand == 1 and "toggle" or "checkbox";
        default = options.default or false,
        folding = options.folding or false, 
        callback = options.callback or function() end,
        items = {};
        seperator = options.seperator or options.Seperator or false;
    }

    flags[cfg.flag] = cfg.default

    local items = cfg.items; do
        items[ "toggle" ] = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.small;
            TextColor3 = rgb(245, 245, 245);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "toggle" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        if cfg.info then 
            items[ "info" ] = library:create( "TextLabel" , {
                FontFace = fonts.small;
                TextColor3 = rgb(130, 130, 130);
                BorderColor3 = rgb(0, 0, 0);
                TextWrapped = true;
                Text = cfg.info;
                Parent = items[ "toggle" ];
                Name = "\0";
                Position = dim2(0, 5, 0, 17);
                Size = dim2(1, -10, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
        end 
        
        library:create( "UIPadding" , { Parent = items[ "name" ]; PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });
        
        items[ "right_components" ] = library:create( "Frame" , {
            Parent = items[ "toggle" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIListLayout" , { FillDirection = Enum.FillDirection.Horizontal; HorizontalAlignment = Enum.HorizontalAlignment.Right; Parent = items[ "right_components" ]; Padding = dim(0, 9); SortOrder = Enum.SortOrder.LayoutOrder });
        
        if cfg.type == "checkbox" then 
            items[ "toggle_button" ] = library:create( "TextButton" , {
                FontFace = fonts.small;
                TextColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Text = "";
                LayoutOrder = 2;
                AutoButtonColor = false;
                AnchorPoint = vec2(1, 0);
                Parent = items[ "right_components" ];
                Name = "\0";
                Position = dim2(1, 0, 0, 0);
                Size = dim2(0, 16, 0, 16);
                BorderSizePixel = 0;
                TextSize = 14;
                BackgroundColor3 = rgb(67, 67, 68)
            }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");
            
            library:create( "UICorner" , { Parent = items[ "toggle_button" ]; CornerRadius = dim(0, 4) });
            
            items[ "outline" ] = library:create( "Frame" , {
                Parent = items[ "toggle_button" ];
                Size = dim2(1, -2, 1, -2);
                Name = "\0";
                BorderMode = Enum.BorderMode.Inset;
                BorderColor3 = rgb(0, 0, 0);
                Position = dim2(0, 1, 0, 1);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(22, 22, 24)
            }); library:apply_theme(items[ "outline" ], "accent", "BackgroundColor3");
            
            items[ "tick" ] = library:create( "ImageLabel" , {
                ImageTransparency = 1;
                BorderColor3 = rgb(0, 0, 0);
                Image = "rbxassetid://111862698467575";
                BackgroundTransparency = 1;
                Position = dim2(0, -1, 0, 0);
                Parent = items[ "outline" ];
                Size = dim2(1, 2, 1, 2);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
                ZIndex = 1;
            });

            library:create( "UICorner" , { Parent = items[ "outline" ]; CornerRadius = dim(0, 4) });
            library:create( "UIGradient" , { Enabled = false; Parent = items[ "outline" ]; Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))} });  
        else 
            -- Gaya oldlib: trek pill + thumb bulat (CreateToggle)
            local track_w, track_h = 44, 24
            local thumb_sz = 18
            local thumb_x_on = track_w - thumb_sz - 2
            local thumb_x_off = 2
            items[ "toggle_button" ] = library:create( "TextButton" , {
                FontFace = fonts.font;
                TextColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Text = "";
                LayoutOrder = 2;
                AutoButtonColor = false;
                AnchorPoint = vec2(1, 0.5);
                Parent = items[ "right_components" ];
                Name = "\0";
                Position = dim2(1, -9, 0.5, 0);
                Size = dim2(0, track_w, 0, track_h);
                BorderSizePixel = 0;
                TextSize = 14;
                BackgroundColor3 = rgb(45, 45, 50);
            })
            library:create( "UICorner" , { Parent = items[ "toggle_button" ]; CornerRadius = dim(1, 0) })
            items[ "toggle_thumb" ] = library:create( "Frame" , {
                Parent = items[ "toggle_button" ];
                Name = "\0";
                AnchorPoint = vec2(0, 0.5);
                Position = dim2(0, thumb_x_off, 0.5, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, thumb_sz, 0, thumb_sz);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
                ZIndex = 2;
            })
            library:create( "UICorner" , { Parent = items[ "toggle_thumb" ]; CornerRadius = dim(1, 0) })
            cfg._toggle_thumb_x_on = thumb_x_on
            cfg._toggle_thumb_x_off = thumb_x_off
            items[ "name" ].Size = dim2(1, -58, 0, 0)
            if items[ "info" ] then
                items[ "info" ].Size = dim2(1, -58, 0, 0)
            end
        end 
    end;
    
    function cfg.set(bool)
        if cfg.type == "checkbox" then 
            library:tween(items[ "tick" ], {Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1})
            library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(67, 67, 68)})
            library:tween(items[ "outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(22, 22, 24)})
        else
            local xon = cfg._toggle_thumb_x_on or 24
            local xoff = cfg._toggle_thumb_x_off or 2
            library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(45, 45, 50)}, Enum.EasingStyle.Quint, 0.3)
            library:tween(items[ "toggle_thumb" ], {Position = bool and dim2(0, xon, 0.5, 0) or dim2(0, xoff, 0.5, 0)}, Enum.EasingStyle.Quint, 0.3)
        end

        cfg.callback(bool)

        if cfg.folding then 
            elements.Visible = bool
        end

        flags[cfg.flag] = bool
    end 
    
    items[ "toggle" ].MouseButton1Click:Connect(function()
        cfg.enabled = not cfg.enabled 
        cfg.set(cfg.enabled)
    end)

    items[ "toggle_button" ].MouseButton1Click:Connect(function()
        cfg.enabled = not cfg.enabled 
        cfg.set(cfg.enabled)
    end)
    
    if cfg.seperator then 
        library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = self.items[ "elements" ];
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 1, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(36, 36, 37)
        });
    end

    cfg.enabled = cfg.default
    cfg.set(cfg.default)
    config_flags[cfg.flag] = cfg.set
    return setmetatable(cfg, library)
end 

function library:slider(options) 
    local step = options.interval
    if step == nil then
        step = options.decimal
    end
    if step == nil or step == 0 then
        step = 1
    end

    local cfg = {
        name = options.name or nil,
        suffix = options.suffix or "",
        flag = options.flag or library:next_flag(),
        callback = options.callback or function() end, 
        info = options.info or nil; 
        min = options.min or options.minimum or 0,
        max = options.max or options.maximum or 100,
        intervals = step,
        default = options.default or 10,
        value = options.default or 10, 
        seperator = options.seperator or options.Seperator or true;
        dragging = false,
        items = {}
    } 

    flags[cfg.flag] = cfg.default

    local items = cfg.items; do
        items[ "slider_object" ] = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.small;
            TextColor3 = rgb(245, 245, 245);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "slider_object" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        if cfg.info then 
            items[ "info" ] = library:create( "TextLabel" , {
                FontFace = fonts.small;
                TextColor3 = rgb(130, 130, 130);
                BorderColor3 = rgb(0, 0, 0);
                TextWrapped = true;
                Text = cfg.info;
                Parent = items[ "slider_object" ];
                Name = "\0";
                Position = dim2(0, 5, 0, 52);
                Size = dim2(1, -10, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
        end 

        library:create( "UIPadding" , { Parent = items[ "name" ]; PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });
        
        items[ "right_components" ] = library:create( "Frame" , {
            Parent = items[ "slider_object" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 4, 0, 28);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 22);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIListLayout" , { Parent = items[ "right_components" ]; Padding = dim(0, 7); SortOrder = Enum.SortOrder.LayoutOrder; FillDirection = Enum.FillDirection.Horizontal });
        
        items[ "slider" ] = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            AutoButtonColor = false;
            AnchorPoint = vec2(1, 0);
            Parent = items[ "right_components" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            Size = dim2(1, -4, 0, 12);
            BorderSizePixel = 0;
            TextSize = 14;
            BackgroundColor3 = rgb(33, 33, 35)
        });
        
        library:create( "UICorner" , { Parent = items[ "slider" ]; CornerRadius = dim(0, 999) });
        
        items[ "fill" ] = library:create( "Frame" , {
            Name = "\0";
            Parent = items[ "slider" ];
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0.5, 0, 0, 12);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.accent
        });  library:apply_theme(items[ "fill" ], "accent", "BackgroundColor3");
        
        library:create( "UICorner" , { Parent = items[ "fill" ]; CornerRadius = dim(0, 999) });
        
        items[ "circle" ] = library:create( "Frame" , {
            AnchorPoint = vec2(0.5, 0.5);
            Parent = items[ "fill" ];
            Name = "\0";
            Position = dim2(1, 0, 0.5, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 18, 0, 18);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(244, 244, 244)
        });
        
        library:create( "UICorner" , { Parent = items[ "circle" ]; CornerRadius = dim(0, 999) });
        library:create( "UIPadding" , { Parent = items[ "right_components" ]; PaddingTop = dim(0, 5) });
        
        items[ "value" ] = library:create( "TextLabel" , {
            FontFace = fonts.small;
            TextColor3 = rgb(72, 72, 73);
            BorderColor3 = rgb(0, 0, 0);
            Text = "50%";
            Parent = items[ "slider_object" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            Position = dim2(0, 6, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Right;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIPadding" , { Parent = items[ "value" ]; PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });                
    end 

    function cfg.set(value)
        cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

        local span = cfg.max - cfg.min
        local frac = span ~= 0 and (cfg.value - cfg.min) / span or 0
        library:tween(items[ "fill" ], {Size = dim2(frac, cfg.value == cfg.min and 0 or -8, 0, 12)}, Enum.EasingStyle.Linear, 0.05)
        items[ "value" ].Text = tostring(cfg.value) .. cfg.suffix

        flags[cfg.flag] = cfg.value
        cfg.callback(flags[cfg.flag])
    end

    items[ "slider" ].MouseButton1Down:Connect(function()
        cfg.dragging = true 
        library:tween(items[ "value" ], {TextColor3 = rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.2)
    end)

    library:connection(uis.InputChanged, function(input)
        if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
            local w = items[ "slider" ].AbsoluteSize.X
            if w <= 0 then
                return
            end
            local size_x = (input.Position.X - items[ "slider" ].AbsolutePosition.X) / w
            size_x = clamp(size_x, 0, 1)
            local value = ((cfg.max - cfg.min) * size_x) + cfg.min
            cfg.set(value)
        end
    end)

    library:connection(uis.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            cfg.dragging = false
            library:tween(items[ "value" ], {TextColor3 = rgb(72, 72, 73)}, Enum.EasingStyle.Quad, 0.2) 
        end 
    end)

    if cfg.seperator then 
        library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = self.items[ "elements" ];
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 1, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(36, 36, 37)
        });
    end 

    cfg.set(cfg.default)
    config_flags[cfg.flag] = cfg.set
    return setmetatable(cfg, library)
end 

function library:dropdown(options) 
    local cfg = {
        name = options.name or nil;
        info = options.info or nil;
        flag = options.flag or library:next_flag();
        options = options.items or {""};
        callback = options.callback or function() end;
        multi = options.multi or false;
        scrolling = options.scrolling or false;
        width = options.width or 130;
        open = false;
        option_instances = {};
        multi_items = {};
        ignore = options.ignore or false;
        items = {};
        y_size = 0;
        seperator = options.seperator or options.Seperator or true;
    }   

    cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or "None"
    flags[cfg.flag] = cfg.default

    local items = cfg.items; do 
        items[ "dropdown_object" ] = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.small;
            TextColor3 = rgb(245, 245, 245);
            BorderColor3 = rgb(0, 0, 0);
            Text = "Dropdown";
            Parent = items[ "dropdown_object" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        if cfg.info then 
            items[ "info" ] = library:create( "TextLabel" , {
                FontFace = fonts.small;
                TextColor3 = rgb(130, 130, 130);
                BorderColor3 = rgb(0, 0, 0);
                TextWrapped = true;
                Text = cfg.info;
                Parent = items[ "dropdown_object" ];
                Name = "\0";
                Position = dim2(0, 5, 0, 17);
                Size = dim2(1, -10, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
        end 

        library:create( "UIPadding" , { Parent = items[ "name" ]; PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });
        
        items[ "right_components" ] = library:create( "Frame" , {
            Parent = items[ "dropdown_object" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIListLayout" , { FillDirection = Enum.FillDirection.Horizontal; HorizontalAlignment = Enum.HorizontalAlignment.Right; Parent = items[ "right_components" ]; Padding = dim(0, 7); SortOrder = Enum.SortOrder.LayoutOrder });
        
        items[ "dropdown" ] = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            AutoButtonColor = false;
            AnchorPoint = vec2(1, 0);
            Parent = items[ "right_components" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            Size = dim2(0, cfg.width, 0, 16);
            BorderSizePixel = 0;
            TextSize = 14;
            BackgroundColor3 = rgb(33, 33, 35)
        });
        
        library:create( "UICorner" , { Parent = items[ "dropdown" ]; CornerRadius = dim(0, 4) });
        
        items[ "sub_text" ] = library:create( "TextLabel" , {
            FontFace = fonts.small;
            TextColor3 = rgb(86, 86, 87);
            BorderColor3 = rgb(0, 0, 0);
            Text = "awdawdawdawdawdawdawdaw";
            Parent = items[ "dropdown" ];
            Name = "\0";
            Size = dim2(1, -12, 0, 0);
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextTruncate = Enum.TextTruncate.AtEnd;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIPadding" , { Parent = items[ "sub_text" ]; PaddingTop = dim(0, 1); PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });
        
        items[ "indicator" ] = library:create( "ImageLabel" , {
            ImageColor3 = rgb(86, 86, 87);
            BorderColor3 = rgb(0, 0, 0);
            Parent = items[ "dropdown" ];
            AnchorPoint = vec2(1, 0.5);
            Image = "rbxassetid://101025591575185";
            BackgroundTransparency = 1;
            Position = dim2(1, -5, 0.5, 0);
            Name = "\0";
            Size = dim2(0, 12, 0, 12);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        items[ "dropdown_holder" ] = library:create( "Frame" , {
            BorderColor3 = rgb(0, 0, 0);
            Parent = library[ "items" ];
            Name = "\0";
            Visible = true;
            BackgroundTransparency = 1;
            Size = dim2(0, 0, 0, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0);
            ZIndex = 10;
        });
        
        items[ "outline" ] = library:create( "Frame" , {
            Parent = items[ "dropdown_holder" ];
            Size = dim2(1, 0, 1, 0);
            ClipsDescendants = true;
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(33, 33, 35);
            ZIndex = 10;
        });
        
        library:create( "UIPadding" , { PaddingBottom = dim(0, 6); PaddingTop = dim(0, 3); PaddingLeft = dim(0, 3); Parent = items[ "outline" ] });
        library:create( "UIListLayout" , { Parent = items[ "outline" ]; Padding = dim(0, 5); SortOrder = Enum.SortOrder.LayoutOrder });
        library:create( "UICorner" , { Parent = items[ "outline" ]; CornerRadius = dim(0, 4) });
    end 

    function cfg.render_option(text)
        local button = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(72, 72, 73);
            BorderColor3 = rgb(0, 0, 0);
            Text = text;
            Parent = items[ "outline" ];
            Name = "\0";
            Size = dim2(1, -12, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255);
            ZIndex = 10;
        }); library:apply_theme(button, "accent", "TextColor3");
        
        library:create( "UIPadding" , { Parent = button; PaddingTop = dim(0, 1); PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });
        return button
    end
    
    function cfg.set_visible(bool)
        local a = bool and cfg.y_size or 0
        library:tween(items[ "dropdown_holder" ], {Size = dim_offset(items[ "dropdown" ].AbsoluteSize.X, a)})

        items[ "dropdown_holder" ].Position = dim2(0, items[ "dropdown" ].AbsolutePosition.X, 0, items[ "dropdown" ].AbsolutePosition.Y + 80)
        if not (self.sanity and library.current_open == self) then 
            library:close_element(cfg)
        end
    end
    
    function cfg.set(value)
        local selected = {}
        local isTable = type(value) == "table"

        for _, option in cfg.option_instances do 
            if option.Text == value or (isTable and find(value, option.Text)) then 
                insert(selected, option.Text)
                cfg.multi_items = selected
                option.TextColor3 = themes.preset.accent
            else
                option.TextColor3 = rgb(72, 72, 73)
            end
        end

        items[ "sub_text" ].Text = isTable and concat(selected, ", ") or selected[1] or ""
        flags[cfg.flag] = isTable and selected or selected[1]
        cfg.callback(flags[cfg.flag]) 
    end
    
    function cfg.refresh_options(list) 
        cfg.y_size = 0
        for _, option in cfg.option_instances do option:Destroy() end
        cfg.option_instances = {} 

        for _, option in list do 
            local button = cfg.render_option(option)
            cfg.y_size = cfg.y_size + button.AbsoluteSize.Y + 6
            insert(cfg.option_instances, button)
            
            button.MouseButton1Down:Connect(function()
                if cfg.multi then 
                    local selected_index = find(cfg.multi_items, button.Text)
                    if selected_index then 
                        remove(cfg.multi_items, selected_index)
                    else
                        insert(cfg.multi_items, button.Text)
                    end
                    cfg.set(cfg.multi_items) 				
                else 
                    cfg.set_visible(false)
                    cfg.open = false 
                    cfg.set(button.Text)
                end
            end)
        end
    end

    items[ "dropdown" ].MouseButton1Click:Connect(function()
        cfg.open = not cfg.open 
        cfg.set_visible(cfg.open)
    end)

    if cfg.seperator then 
        library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = self.items[ "elements" ];
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 1, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(36, 36, 37)
        });
    end 

    flags[cfg.flag] = {} 
    config_flags[cfg.flag] = cfg.set
    
    cfg.refresh_options(cfg.options)
    cfg.set(cfg.default)
        
    return setmetatable(cfg, library)
end

function library:label(options)
    local cfg = {
        enabled = options.enabled or nil,
        name = options.name or "Toggle",
        seperator = options.seperator or options.Seperator or false;
        info = options.info or nil; 
        items = {};
    }

    local items = cfg.items; do 
        items[ "label" ] = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.small;
            TextColor3 = rgb(245, 245, 245);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "label" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });

        if cfg.info then 
            items[ "info" ] = library:create( "TextLabel" , {
                FontFace = fonts.small;
                TextColor3 = rgb(130, 130, 130);
                BorderColor3 = rgb(0, 0, 0);
                TextWrapped = true;
                Text = cfg.info;
                Parent = items[ "label" ];
                Name = "\0";
                Position = dim2(0, 5, 0, 17);
                Size = dim2(1, -10, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
        end 
        
        library:create( "UIPadding" , { Parent = items[ "name" ]; PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });
        
        items[ "right_components" ] = library:create( "Frame" , {
            Parent = items[ "label" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIListLayout" , { FillDirection = Enum.FillDirection.Horizontal; HorizontalAlignment = Enum.HorizontalAlignment.Right; Parent = items[ "right_components" ]; Padding = dim(0, 9); SortOrder = Enum.SortOrder.LayoutOrder });                
    end 

    if cfg.seperator then 
        library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = self.items[ "elements" ];
            Position = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 1, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(36, 36, 37)
        });
    end 

    return setmetatable(cfg, library)
end 

function library:colorpicker(options) 
    local cfg = {
        name = options.name or "Color", 
        flag = options.flag or library:next_flag(),
        color = options.color or color(1, 1, 1),
        alpha = options.alpha and 1 - options.alpha or 0,
        open = false, 
        callback = options.callback or function() end,
        items = {};
        seperator = options.seperator or options.Seperator or false;
    }

    local dragging_sat = false 
    local dragging_hue = false 
    local dragging_alpha = false 

    local h, s, v = cfg.color:ToHSV() 
    local a = cfg.alpha 

    flags[cfg.flag] = {Color = cfg.color, Transparency = cfg.alpha}

    local label; 
    if not self.items.right_components then 
        label = self:label({name = cfg.name, seperator = cfg.seperator})
    end

    local items = cfg.items; do 
        items[ "colorpicker" ] = library:create( "TextButton" , {
            FontFace = fonts.small;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            AutoButtonColor = false;
            AnchorPoint = vec2(1, 0);
            Parent = label and label.items.right_components or self.items[ "right_components" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            Size = dim2(0, 16, 0, 16);
            BorderSizePixel = 0;
            TextSize = 14;
            BackgroundColor3 = rgb(54, 31, 184)
        });
        
        library:create( "UICorner" , { Parent = items[ "colorpicker" ]; CornerRadius = dim(0, 4) });
        
        items[ "colorpicker_inline" ] = library:create( "Frame" , {
            Parent = items[ "colorpicker" ];
            Size = dim2(1, -2, 1, -2);
            Name = "\0";
            BorderMode = Enum.BorderMode.Inset;
            BorderColor3 = rgb(0, 0, 0);
            Position = dim2(0, 1, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(54, 31, 184)
        });
        
        library:create( "UICorner" , { Parent = items[ "colorpicker_inline" ]; CornerRadius = dim(0, 4) });
        library:create( "UIGradient" , { Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))}; Parent = items[ "colorpicker_inline" ] });         
        
        items[ "colorpicker_holder" ] = library:create( "Frame" , {
            Parent = library[ "other" ];
            Name = "\0";
            Position = dim2(0.20000000298023224, 20, 0.296999990940094, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 166, 0, 197);
            BorderSizePixel = 0;
            Visible = true;
            BackgroundColor3 = rgb(25, 25, 29)
        });

        items[ "colorpicker_fade" ] = library:create( "Frame" , {
            Parent = items[ "colorpicker_holder" ];
            Name = "\0";
            BackgroundTransparency = 0;
            Position = dim2(0, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 1, 0);
            BorderSizePixel = 0;
            ZIndex = 100;
            BackgroundColor3 = rgb(25, 25, 29)
        });
        
        items[ "colorpicker_components" ] = library:create( "Frame" , {
            Parent = items[ "colorpicker_holder" ];
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(22, 22, 24)
        });
        
        library:create( "UICorner" , { Parent = items[ "colorpicker_components" ]; CornerRadius = dim(0, 6) });
        
        items[ "saturation_holder" ] = library:create( "Frame" , {
            Parent = items[ "colorpicker_components" ];
            Name = "\0";
            Position = dim2(0, 7, 0, 7);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -14, 1, -80);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 39, 39)
        });
        
        items[ "sat" ] = library:create( "TextButton" , {
            Parent = items[ "saturation_holder" ];
            Name = "\0";
            Size = dim2(1, 0, 1, 0);
            Text = "";
            AutoButtonColor = false;
            BorderColor3 = rgb(0, 0, 0);
            ZIndex = 2;
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UICorner" , { Parent = items[ "sat" ]; CornerRadius = dim(0, 4) });
        library:create( "UIGradient" , { Rotation = 270; Transparency = numseq{numkey(0, 0), numkey(1, 1)}; Parent = items[ "sat" ]; Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))} });
        
        items[ "val" ] = library:create( "Frame" , {
            Name = "\0";
            Parent = items[ "saturation_holder" ];
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIGradient" , { Parent = items[ "val" ]; Transparency = numseq{numkey(0, 0), numkey(1, 1)} });
        library:create( "UICorner" , { Parent = items[ "val" ]; CornerRadius = dim(0, 4) });
        library:create( "UICorner" , { Parent = items[ "saturation_holder" ]; CornerRadius = dim(0, 4) });
        
        items[ "satvalpicker" ] = library:create( "TextButton" , {
            BorderColor3 = rgb(0, 0, 0);
            AutoButtonColor = false;
            Text = "";
            AnchorPoint = vec2(0, 1);
            Parent = items[ "saturation_holder" ];
            Name = "\0";
            Position = dim2(0, 0, 4, 0);
            Size = dim2(0, 8, 0, 8);
            ZIndex = 5;
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 0, 0)
        });
        
        library:create( "UICorner" , { Parent = items[ "satvalpicker" ]; CornerRadius = dim(0, 9999) });
        library:create( "UIStroke" , { Color = rgb(255, 255, 255); Parent = items[ "satvalpicker" ]; ApplyStrokeMode = Enum.ApplyStrokeMode.Border; });
        
        items[ "hue_gradient" ] = library:create( "TextButton" , {
            Parent = items[ "colorpicker_components" ];
            Name = "\0";
            Position = dim2(0, 10, 1, -64);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -20, 0, 8);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255);
            AutoButtonColor = false;
            Text = "";
        });
        
        library:create( "UIGradient" , { Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))}; Parent = items[ "hue_gradient" ] });
        library:create( "UICorner" , { Parent = items[ "hue_gradient" ]; CornerRadius = dim(0, 6) });
        
        items[ "hue_picker" ] = library:create( "TextButton" , {
            BorderColor3 = rgb(0, 0, 0);
            AutoButtonColor = false;
            Text = "";
            AnchorPoint = vec2(0, 0.5);
            Parent = items[ "hue_gradient" ];
            Name = "\0";
            Position = dim2(0, 0, 0.5, 0);
            Size = dim2(0, 8, 0, 8);
            ZIndex = 5;
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 0, 0)
        });
        
        library:create( "UICorner" , { Parent = items[ "hue_picker" ]; CornerRadius = dim(0, 9999) });
        library:create( "UIStroke" , { Color = rgb(255, 255, 255); Parent = items[ "hue_picker" ]; ApplyStrokeMode = Enum.ApplyStrokeMode.Border; });
        
        items[ "alpha_gradient" ] = library:create( "TextButton" , {
            Parent = items[ "colorpicker_components" ];
            Name = "\0";
            Position = dim2(0, 10, 1, -46);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -20, 0, 8);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(25, 25, 29);
            AutoButtonColor = false;
            Text = "";
        });
        
        library:create( "UICorner" , { Parent = items[ "alpha_gradient" ]; CornerRadius = dim(0, 6) });
        
        items[ "alpha_picker" ] = library:create( "TextButton" , {
            BorderColor3 = rgb(0, 0, 0);
            AutoButtonColor = false;
            Text = "";
            AnchorPoint = vec2(0, 0.5);
            Parent = items[ "alpha_gradient" ];
            Name = "\0";
            Position = dim2(1, 0, 0.5, 0);
            Size = dim2(0, 8, 0, 8);
            ZIndex = 5;
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 0, 0)
        });
        
        library:create( "UICorner" , { Parent = items[ "alpha_picker" ]; CornerRadius = dim(0, 9999) });
        library:create( "UIStroke" , { Color = rgb(255, 255, 255); ApplyStrokeMode = Enum.ApplyStrokeMode.Border; Parent = items[ "alpha_picker" ] });
        library:create( "UIGradient" , { Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(255, 255, 255))}; Parent = items[ "alpha_gradient" ] });
        
        items[ "alpha_indicator" ] = library:create( "ImageLabel" , {
            ScaleType = Enum.ScaleType.Tile;
            BorderColor3 = rgb(0, 0, 0);
            Parent = items[ "alpha_gradient" ];
            Image = "rbxassetid://18274452449";
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(1, 0, 1, 0);
            TileSize = dim2(0, 6, 0, 6);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0)
        });
        
        library:create( "UIGradient" , { Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, rgb(255, 0, 0))}; Transparency = numseq{numkey(0, 0.8062499761581421), numkey(1, 0)}; Parent = items[ "alpha_indicator" ] });
        library:create( "UICorner" , { Parent = items[ "alpha_indicator" ]; CornerRadius = dim(0, 6) });
        library:create( "UIGradient" , { Rotation = 90; Parent = items[ "colorpicker_components" ]; Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(66, 66, 66))} });

        items[ "input" ] = library:create( "TextBox" , {
            FontFace = fonts.font;
            AnchorPoint = vec2(1, 1);
            Text = "";
            Parent = items[ "colorpicker_components" ];
            Name = "\0";
            TextTruncate = Enum.TextTruncate.AtEnd;
            BorderSizePixel = 0;
            PlaceholderColor3 = rgb(255, 255, 255);
            CursorPosition = -1;
            ClearTextOnFocus = false;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255);
            TextColor3 = rgb(72, 72, 72);
            BorderColor3 = rgb(0, 0, 0);
            Position = dim2(1, -8, 1, -11);
            Size = dim2(1, -16, 0, 18);
            BackgroundColor3 = rgb(33, 33, 35)
        }); 
        
        library:create( "UICorner" , { Parent = items[ "input" ]; CornerRadius = dim(0, 3) });
        items[ "UICorenr" ] = library:create( "UICorner" , { Parent = items[ "colorpicker_holder" ]; Name = "\0"; CornerRadius = dim(0, 4) });
    end;

    function cfg.set_visible(bool)
        items[ "colorpicker_fade" ].BackgroundTransparency = 0
        items[ "colorpicker_holder" ].Parent = bool and library[ "items" ] or library[ "other" ]
        items[ "colorpicker_holder" ].Position = dim_offset(items[ "colorpicker" ].AbsolutePosition.X, items[ "colorpicker" ].AbsolutePosition.Y + items[ "colorpicker" ].AbsoluteSize.Y + 45)

        library:tween(items[ "colorpicker_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
        library:tween(items[ "colorpicker_holder" ], {Position = items[ "colorpicker_holder" ].Position + dim_offset(0, 20)}) 
        
        if not (self.sanity and library.current_open == self and self.open) then 
            library:close_element(cfg)
        end
    end

    function cfg.set(color, alpha)
        if type(color) == "boolean" then return end 
        if color then h, s, v = color:ToHSV() end
        if alpha then a = alpha end 
        
        local Color = hsv(h, s, v)

        library:tween(items[ "hue_picker" ], {Position = dim2(0, (items[ "hue_gradient" ].AbsoluteSize.X - items[ "hue_picker" ].AbsoluteSize.X) * h, 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
        library:tween(items[ "alpha_picker" ], {Position = dim2(0, (items[ "alpha_gradient" ].AbsoluteSize.X - items[ "alpha_picker" ].AbsoluteSize.X) * (1 - a), 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
        library:tween(items[ "satvalpicker" ], {Position = dim2(0, s * (items[ "saturation_holder" ].AbsoluteSize.X - items[ "satvalpicker" ].AbsoluteSize.X), 1, 1 - v * (items[ "saturation_holder" ].AbsoluteSize.Y - items[ "satvalpicker" ].AbsoluteSize.Y))}, Enum.EasingStyle.Linear, 0.05)

        items[ "alpha_indicator" ]:FindFirstChildOfClass("UIGradient").Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1))};
        
        items[ "colorpicker" ].BackgroundColor3 = Color
        items[ "colorpicker_inline" ].BackgroundColor3 = Color
        items[ "saturation_holder" ].BackgroundColor3 = hsv(h, 1, 1)

        items[ "hue_picker" ].BackgroundColor3 = hsv(h, 1, 1)
        items[ "alpha_picker" ].BackgroundColor3 = hsv(h, 1, 1 - a)
        items[ "satvalpicker" ].BackgroundColor3 = hsv(h, s, v)

        flags[cfg.flag] = { Color = Color; Transparency = a }
        
        local color = items[ "colorpicker" ].BackgroundColor3
        items[ "input" ].Text = string.format("%s, %s, %s, ", library:round(color.R * 255), library:round(color.G * 255), library:round(color.B * 255))
        items[ "input" ].Text ..= library:round(1 - a, 0.01)
        
        cfg.callback(Color, a)
    end
    
    function cfg.update_color() 
        local mouse = uis:GetMouseLocation() 
        local offset = vec2(mouse.X, mouse.Y - gui_offset) 

        if dragging_sat then	
            s = math.clamp((offset - items["sat"].AbsolutePosition).X / items["sat"].AbsoluteSize.X, 0, 1)
            v = 1 - math.clamp((offset - items["sat"].AbsolutePosition).Y / items["sat"].AbsoluteSize.Y, 0, 1)
        elseif dragging_hue then
            h = math.clamp((offset - items[ "hue_gradient" ].AbsolutePosition).X / items[ "hue_gradient" ].AbsoluteSize.X, 0, 1)
        elseif dragging_alpha then
            a = 1 - math.clamp((offset - items[ "alpha_gradient" ].AbsolutePosition).X / items[ "alpha_gradient" ].AbsoluteSize.X, 0, 1)
        end

        cfg.set()
    end

    items[ "colorpicker" ].MouseButton1Click:Connect(function()
        cfg.open = not cfg.open 
        cfg.set_visible(cfg.open)            
    end)

    uis.InputChanged:Connect(function(input)
        if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
            cfg.update_color() 
        end
    end)

    library:connection(uis.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging_sat = false
            dragging_hue = false
            dragging_alpha = false
        end
    end)    

    items[ "alpha_gradient" ].MouseButton1Down:Connect(function() dragging_alpha = true end)
    items[ "hue_gradient" ].MouseButton1Down:Connect(function() dragging_hue = true end)
    items[ "sat" ].MouseButton1Down:Connect(function() dragging_sat = true end)

    items[ "input" ].FocusLost:Connect(function()
        local text = items[ "input" ].Text
        local r, g, b, a = library:convert(text)
        if r and g and b and a then cfg.set(rgb(r, g, b), 1 - a) end 
    end)

    items[ "input" ].Focused:Connect(function() library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)}) end)
    items[ "input" ].FocusLost:Connect(function() library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)}) end)
    
    cfg.set(cfg.color, cfg.alpha)
    config_flags[cfg.flag] = cfg.set

    return setmetatable(cfg, library)
end 

function library:textbox(options) 
    local cfg = {
        name = options.name or "TextBox",
        placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
        default = options.default or "",
        flag = options.flag or library:next_flag(),
        callback = options.callback or function() end,
        visible = options.visible or true,
        items = {};
    }

    flags[cfg.flag] = cfg.default

    local items = cfg.items; do 
        items[ "textbox" ] = library:create( "TextButton" , {
            LayoutOrder = -1;
            FontFace = fonts.font;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = rgb(245, 245, 245);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "textbox" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIPadding" , { Parent = items[ "name" ]; PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });
        
        items[ "right_components" ] = library:create( "Frame" , {
            Parent = items[ "textbox" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 4, 0, 19);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 12);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIListLayout" , { Parent = items[ "right_components" ]; Padding = dim(0, 7); SortOrder = Enum.SortOrder.LayoutOrder; FillDirection = Enum.FillDirection.Horizontal });
        
        items[ "input" ] = library:create( "TextBox" , {
            FontFace = fonts.font;
            Text = "";
            Parent = items[ "right_components" ];
            Name = "\0";
            TextTruncate = Enum.TextTruncate.AtEnd;
            BorderSizePixel = 0;
            PlaceholderColor3 = rgb(255, 255, 255);
            CursorPosition = -1;
            ClearTextOnFocus = false;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255);
            TextColor3 = rgb(72, 72, 72);
            BorderColor3 = rgb(0, 0, 0);
            Position = dim2(1, 0, 0, 0);
            Size = dim2(1, -4, 0, 30);
            BackgroundColor3 = rgb(33, 33, 35)
        }); 

        library:create( "UICorner" , { Parent = items[ "input" ]; CornerRadius = dim(0, 3) });                
        library:create( "UIPadding" , { Parent = items[ "right_components" ]; PaddingTop = dim(0, 4); PaddingRight = dim(0, 4) });
    end 
    
    function cfg.set(text) 
        flags[cfg.flag] = text
        items[ "input" ].Text = text
        cfg.callback(text)
    end 
    
    items[ "input" ]:GetPropertyChangedSignal("Text"):Connect(function() cfg.set(items[ "input" ].Text) end)
    items[ "input" ].Focused:Connect(function() library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)}) end)
    items[ "input" ].FocusLost:Connect(function() library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)}) end)
        
    if cfg.default then cfg.set(cfg.default) end
    config_flags[cfg.flag] = cfg.set

    return setmetatable(cfg, library)
end

function library:keybind(options) 
    local cfg = {
        flag = options.flag or library:next_flag(),
        callback = options.callback or function() end,
        name = options.name or nil, 
        ignore_key = options.ignore or false, 
        key = options.key or nil, 
        mode = options.mode or "Toggle",
        active = options.default or false, 
        open = false,
        binding = nil, 
        hold_instances = {},
        items = {};
    }

    flags[cfg.flag] = { mode = cfg.mode, key = cfg.key, active = cfg.active }

    local items = cfg.items; do 
        items[ "keybind_element" ] = library:create( "TextButton" , {
            FontFace = fonts.font;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = rgb(245, 245, 245);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "keybind_element" ];
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 16;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIPadding" , { Parent = items[ "name" ]; PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });
        
        items[ "right_components" ] = library:create( "Frame" , {
            Parent = items[ "keybind_element" ];
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIListLayout" , { FillDirection = Enum.FillDirection.Horizontal; HorizontalAlignment = Enum.HorizontalAlignment.Right; Parent = items[ "right_components" ]; Padding = dim(0, 7); SortOrder = Enum.SortOrder.LayoutOrder });
        
        items[ "keybind_holder" ] = library:create( "TextButton" , {
            FontFace = fonts.font;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = items[ "right_components" ];
            AutoButtonColor = false;
            AnchorPoint = vec2(1, 0);
            Size = dim2(0, 0, 0, 16);
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.X;
            TextSize = 14;
            BackgroundColor3 = rgb(33, 33, 35)
        });
        
        library:create( "UICorner" , { Parent = items[ "keybind_holder" ]; CornerRadius = dim(0, 4) });
        
        items[ "key" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = rgb(86, 86, 87);
            BorderColor3 = rgb(0, 0, 0);
            Text = "LSHIFT";
            Parent = items[ "keybind_holder" ];
            Name = "\0";
            Size = dim2(1, -12, 0, 0);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIPadding" , { Parent = items[ "key" ]; PaddingTop = dim(0, 1); PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });                                  

        items[ "dropdown" ] = library:create( "Frame" , {
            BorderColor3 = rgb(0, 0, 0);
            Parent = library.items;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 0, 0);
            Size = dim2(0, 0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.X;
            BackgroundColor3 = rgb(0, 0, 0)
        });
        
        items[ "inline" ] = library:create( "Frame" , {
            Parent = items[ "dropdown" ];
            Size = dim2(1, 0, 1, 0);
            Name = "\0";
            ClipsDescendants = true;
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(22, 22, 24)
        });
        
        library:create( "UIPadding" , { PaddingBottom = dim(0, 6); PaddingTop = dim(0, 3); PaddingLeft = dim(0, 3); Parent = items[ "inline" ] });
        library:create( "UIListLayout" , { Parent = items[ "inline" ]; Padding = dim(0, 5); SortOrder = Enum.SortOrder.LayoutOrder });
        library:create( "UICorner" , { Parent = items[ "inline" ]; CornerRadius = dim(0, 4) });
        
        local options = {"Hold", "Toggle", "Always"}
        
        cfg.y_size = 20
        for _, option in options do                        
            local name = library:create( "TextButton" , {
                FontFace = fonts.font;
                TextColor3 = rgb(72, 72, 73);
                BorderColor3 = rgb(0, 0, 0);
                Text = option;
                Parent = items[ "inline" ];
                Name = "\0";
                Size = dim2(0, 0, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            }); cfg.hold_instances[option] = name
            library:apply_theme(name, "accent", "TextColor3")
            
            cfg.y_size = cfg.y_size + name.AbsoluteSize.Y
            library:create( "UIPadding" , { Parent = name; PaddingTop = dim(0, 1); PaddingRight = dim(0, 5); PaddingLeft = dim(0, 5) });

            name.MouseButton1Click:Connect(function()
                cfg.set(option)
                cfg.set_visible(false)
                cfg.open = false
            end)
        end
    end 
    
    function cfg.modify_mode_color(path)
        for _, v in cfg.hold_instances do v.TextColor3 = rgb(72, 72, 72) end 
        cfg.hold_instances[path].TextColor3 = themes.preset.accent
    end

    function cfg.set_mode(mode) 
        cfg.mode = mode 
        if mode == "Always" then cfg.set(true) elseif mode == "Hold" then cfg.set(false) end
        flags[cfg.flag]["mode"] = mode
        cfg.modify_mode_color(mode)
    end 

    function cfg.set(input)
        if type(input) == "boolean" then 
            cfg.active = input
            if cfg.mode == "Always" then cfg.active = true end
        elseif tostring(input):find("Enum") then 
            input = input.Name == "Escape" and "NONE" or input
            cfg.key = input or "NONE"	
        elseif find({"Toggle", "Hold", "Always"}, input) then 
            if input == "Always" then cfg.active = true end 
            cfg.mode = input
            cfg.set_mode(cfg.mode) 
        elseif type(input) == "table" then 
            input.key = type(input.key) == "string" and input.key ~= "NONE" and library:convert_enum(input.key) or input.key
            input.key = input.key == Enum.KeyCode.Escape and "NONE" or input.key
            cfg.key = input.key or "NONE"
            cfg.mode = input.mode or "Toggle"
            if input.active then cfg.active = input.active end
            cfg.set_mode(cfg.mode) 
        end 

        cfg.callback(cfg.active)
        local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
        local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))
        items[ "key" ].Text = __text

        flags[cfg.flag] = { mode = cfg.mode, key = cfg.key, active = cfg.active }
    end

    function cfg.set_visible(bool)
        local size = bool and cfg.y_size or 0
        library:tween(items[ "dropdown" ], {Size = dim_offset(items[ "keybind_holder" ].AbsoluteSize.X, size)})
        items[ "dropdown" ].Position = dim_offset(items[ "keybind_holder" ].AbsolutePosition.X, items[ "keybind_holder" ].AbsolutePosition.Y + items[ "keybind_holder" ].AbsoluteSize.Y + 60)
    end

    items[ "keybind_holder" ].MouseButton1Down:Connect(function()
        task.wait()
        items[ "key" ].Text = "..."	
        cfg.binding = library:connection(uis.InputBegan, function(keycode, game_event)  
            cfg.set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)
            cfg.binding:Disconnect() 
            cfg.binding = nil
        end)
    end)

    items[ "keybind_holder" ].MouseButton2Down:Connect(function()
        cfg.open = not cfg.open 
        cfg.set_visible(cfg.open)
    end)

    library:connection(uis.InputBegan, function(input, game_event) 
        if not game_event then
            local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
            if selected_key == cfg.key then 
                if cfg.mode == "Toggle" then 
                    cfg.active = not cfg.active
                    cfg.set(cfg.active)
                elseif cfg.mode == "Hold" then 
                    cfg.set(true)
                end
            end
        end
    end)    

    library:connection(uis.InputEnded, function(input, game_event) 
        if game_event then return end 
        local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
        if selected_key == cfg.key then
            if cfg.mode == "Hold" then cfg.set(false) end
        end
    end)
    
    cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})           
    config_flags[cfg.flag] = cfg.set

    return setmetatable(cfg, library)
end

function library:button(options) 
    local cfg = {
        name = options.name or "TextBox",
        callback = options.callback or function() end,
        items = {};
    }
    
    local items = cfg.items; do 
        items[ "button_element" ] = library:create( "Frame" , {
            Parent = self.items[ "elements" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        items[ "button" ] = library:create( "TextButton" , {
            FontFace = fonts.font;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            AutoButtonColor = false;
            AnchorPoint = vec2(1, 0);
            Parent = items[ "button_element" ];
            Name = "\0";
            Position = dim2(1, -4, 0, 0);
            Size = dim2(1, -8, 0, 30);
            BorderSizePixel = 0;
            TextSize = 14;
            BackgroundColor3 = rgb(33, 33, 35)
        });
        
        library:create( "UICorner" , { Parent = items[ "button" ]; CornerRadius = dim(0, 3) });
        
        items[ "name" ] = library:create( "TextLabel" , {
            FontFace = fonts.small;
            TextColor3 = rgb(245, 245, 245);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "button" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 1, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        }); library:apply_theme(items[ "name" ], "accent", "BackgroundColor3");                            
    end 

    items[ "button" ].MouseButton1Click:Connect(function()
        cfg.callback()
        items[ "name" ].TextColor3 = themes.preset.accent 
        library:tween(items[ "name" ], {TextColor3 = rgb(245, 245, 245)})
    end)
    
    return setmetatable(cfg, library)
end 

function library:list(properties) 
    local cfg = {
        items = {};
        options = properties.options or {"1", "2", "3"};
        flag = properties.flag or library:next_flag();    
        callback = properties.callback or function() end;
        data_store = {};        
        current_element = nil;
    }

    local items = cfg.items; do
        items[ "list" ] = library:create( "Frame" , {
            Parent = self.items[ "elements" ];
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIListLayout" , { Parent = items[ "list" ]; Padding = dim(0, 10); SortOrder = Enum.SortOrder.LayoutOrder });
        library:create( "UIPadding" , { Parent = items[ "list" ]; PaddingRight = dim(0, 4); PaddingLeft = dim(0, 4) });
    end 

    function cfg.refresh_options(options_to_refresh) 
        for _,option in cfg.data_store do option:Destroy() end

        for _, option_data in options_to_refresh do 
            local button = library:create( "TextButton" , {
                FontFace = fonts.small;
                TextColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Text = "";
                AutoButtonColor = false;
                AnchorPoint = vec2(1, 0);
                Parent = items[ "list" ];
                Name = "\0";
                Position = dim2(1, 0, 0, 0);
                Size = dim2(1, 0, 0, 30);
                BorderSizePixel = 0;
                TextSize = 14;
                BackgroundColor3 = rgb(33, 33, 35)
            }); cfg.data_store[#cfg.data_store + 1] = button;

            local name = library:create( "TextLabel" , {
                FontFace = fonts.font;
                TextColor3 = rgb(72, 72, 73);
                BorderColor3 = rgb(0, 0, 0);
                Text = option_data;
                Parent = button;
                Name = "\0";
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 1, 0);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            library:create( "UICorner" , { Parent = button; CornerRadius = dim(0, 3) });     

            button.MouseButton1Click:Connect(function()
                local current = cfg.current_element 
                if current and current ~= name then library:tween(current, {TextColor3 = rgb(72, 72, 72)}) end
                flags[cfg.flag] = option_data
                cfg.callback(option_data)
                library:tween(name, {TextColor3 = rgb(245, 245, 245)})
                cfg.current_element = name
            end)

            name.MouseEnter:Connect(function()
                if cfg.current_element == name then return end 
                library:tween(name, {TextColor3 = rgb(140, 140, 140)})
            end)

            name.MouseLeave:Connect(function()
                if cfg.current_element == name then return end 
                library:tween(name, {TextColor3 = rgb(72, 72, 72)})
            end)
        end
    end

    cfg.refresh_options(cfg.options)
    return setmetatable(cfg, library)
end 

-- FIXED INIT CONFIG (Must be right before notification library)
function library:init_config(subtab_obj) 
    if not subtab_obj then return end
    
    local column = subtab_obj:column({})
    local section = column:section({name = "Config Manager", size = 1, default = true, icon = "rbxassetid://139628202576511"})
    
    section:textbox({name = "Config Name", flag = "cfg_name", default = "default"})
    
    section:button({name = "Save Config", callback = function()
        local name = flags["cfg_name"] or "default"
        writefile(library.directory .. "/configs/" .. name .. ".cfg", library:get_config())
        library.notifications:create_notification({name = "Configs", info = "Saved config: " .. name .. ".cfg"})
    end})

    section:button({name = "Load Config", callback = function()
        local name = flags["cfg_name"] or "default"
        local path = library.directory .. "/configs/" .. name .. ".cfg"
        if isfile(path) then
            library:load_config(readfile(path))
            library.notifications:create_notification({name = "Configs", info = "Loaded config: " .. name .. ".cfg"})
        else
            library.notifications:create_notification({name = "Error", info = "Config not found!"})
        end
    end})
    
    section:colorpicker({name = "Menu Accent", callback = function(color, alpha) library:update_theme("accent", color) end, color = themes.preset.accent})
    section:keybind({name = "Menu Bind", callback = function(bool) library.items.Enabled = bool end, default = true, mode = "Toggle", key = Enum.KeyCode.RightShift})
end

-- Notification Library
function notifications:refresh_notifs() 
    local offset = 50
    for i, v in notifications.notifs do
        local Position = vec2(20, offset)
        library:tween(v, {Position = dim_offset(Position.X, Position.Y)}, Enum.EasingStyle.Quad, 0.4)
        offset = offset + (v.AbsoluteSize.Y + 10)
    end
    return offset
end

function notifications:fade(path, is_fading)
    local fading = is_fading and 1 or 0 
    library:tween(path, {BackgroundTransparency = fading}, Enum.EasingStyle.Quad, 1)

    for _, instance in path:GetDescendants() do 
        if not instance:IsA("GuiObject") then 
            if instance:IsA("UIStroke") then
                library:tween(instance, {Transparency = fading}, Enum.EasingStyle.Quad, 1)
            end
            continue
        end 

        if instance:IsA("TextLabel") then
            library:tween(instance, {TextTransparency = fading})
        elseif instance:IsA("Frame") then
            library:tween(instance, {BackgroundTransparency = instance.Transparency and 0.6 and is_fading and 1 or 0.6}, Enum.EasingStyle.Quad, 1)
        end
    end
end 

function notifications:create_notification(options)
    local cfg = {
        name = options.name or "This is a title!";
        info = options.info or "This is extra info!";
        lifetime = options.lifetime or 3;
        items = {};
        outline = nil;
    }

    local items = cfg.items; do 
        items[ "notification" ] = library:create( "Frame" , {
            Parent = library[ "items" ];
            Size = dim2(0, 210, 0, 53);
            Name = "\0";
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            AnchorPoint = vec2(1, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundColor3 = rgb(14, 14, 16)
        });
        
        library:create( "UIStroke" , { Color = rgb(23, 23, 29); Parent = items[ "notification" ]; Transparency = 1; ApplyStrokeMode = Enum.ApplyStrokeMode.Border });
        
        items[ "title" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = rgb(255, 255, 255);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.name;
            Parent = items[ "notification" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 7, 0, 6);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UICorner" , { Parent = items[ "notification" ]; CornerRadius = dim(0, 3) });
        
        items[ "info" ] = library:create( "TextLabel" , {
            FontFace = fonts.font;
            TextColor3 = rgb(145, 145, 145);
            BorderColor3 = rgb(0, 0, 0);
            Text = cfg.info;
            Parent = items[ "notification" ];
            Name = "\0";
            Position = dim2(0, 9, 0, 22);
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextWrapped = true;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        library:create( "UIPadding" , { PaddingBottom = dim(0, 17); PaddingRight = dim(0, 8); Parent = items[ "info" ] });
        
        items[ "bar" ] = library:create( "Frame" , {
            AnchorPoint = vec2(0, 1);
            Parent = items[ "notification" ];
            Name = "\0";
            Position = dim2(0, 8, 1, -6);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 0, 5);
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.accent
        });
        
        library:create( "UICorner" , { Parent = items[ "bar" ]; CornerRadius = dim(0, 999) });
        library:create( "UIPadding" , { PaddingRight = dim(0, 8); Parent = items[ "notification" ] });
    end
    
    local index = #notifications.notifs + 1
    notifications.notifs[index] = items[ "notification" ]

    notifications:fade(items[ "notification" ], false)
    local offset = notifications:refresh_notifs()
    items[ "notification" ].Position = dim_offset(20, offset)

    library:tween(items[ "notification" ], {AnchorPoint = vec2(0, 0)}, Enum.EasingStyle.Quad, 1)
    library:tween(items[ "bar" ], {Size = dim2(1, -8, 0, 5)}, Enum.EasingStyle.Quad, cfg.lifetime)

    task.spawn(function()
        task.wait(cfg.lifetime)
        notifications.notifs[index] = nil
        notifications:fade(items[ "notification" ], true)
        library:tween(items[ "notification" ], {AnchorPoint = vec2(1, 0)}, Enum.EasingStyle.Quad, 1)
        task.wait(1)
        items[ "notification" ]:Destroy() 
    end)
end

return library
