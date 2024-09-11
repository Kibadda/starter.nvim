local M = {}

local data = {
  {
    "███┐   ███┐ ██████┐ ███┐   ██┐██████┐  █████┐ ██┐   ██┐",
    "████┐ ████│██┌───██┐████┐  ██│██┌──██┐██┌──██┐└██┐ ██┌┘",
    "██┌████┌██│██│   ██│██┌██┐ ██│██│  ██│███████│ └████┌┘ ",
    "██│└██┌┘██│██│   ██│██│└██┐██│██│  ██│██┌──██│  └██┌┘  ",
    "██│ └─┘ ██│└██████┌┘██│ └████│██████┌┘██│  ██│   ██│   ",
    "└─┘     └─┘ └─────┘ └─┘  └───┘└─────┘ └─┘  └─┘   └─┘   ",
  },
  {
    "████████┐██┐   ██┐███████┐███████┐██████┐  █████┐ ██┐   ██┐",
    "└──██┌──┘██│   ██│██┌────┘██┌────┘██┌──██┐██┌──██┐└██┐ ██┌┘",
    "   ██│   ██│   ██│█████┐  ███████┐██│  ██│███████│ └████┌┘ ",
    "   ██│   ██│   ██│██┌──┘  └────██│██│  ██│██┌──██│  └██┌┘  ",
    "   ██│   └██████┌┘███████┐███████│██████┌┘██│  ██│   ██│   ",
    "   └─┘    └─────┘ └──────┘└──────┘└─────┘ └─┘  └─┘   └─┘   ",
  },
  {
    "██┐    ██┐███████┐██████┐ ███┐   ██┐███████┐███████┐██████┐  █████┐ ██┐   ██┐",
    "██│    ██│██┌────┘██┌──██┐████┐  ██│██┌────┘██┌────┘██┌──██┐██┌──██┐└██┐ ██┌┘",
    "██│ █┐ ██│█████┐  ██│  ██│██┌██┐ ██│█████┐  ███████┐██│  ██│███████│ └████┌┘ ",
    "██│███┐██│██┌──┘  ██│  ██│██│└██┐██│██┌──┘  └────██│██│  ██│██┌──██│  └██┌┘  ",
    "└███┌███┌┘███████┐██████┌┘██│ └████│███████┐███████│██████┌┘██│  ██│   ██│   ",
    " └──┘└──┘ └──────┘└─────┘ └─┘  └───┘└──────┘└──────┘└─────┘ └─┘  └─┘   └─┘   ",
  },
  {
    "████████┐██┐  ██┐██┐   ██┐██████┐ ███████┐██████┐  █████┐ ██┐   ██┐",
    "└──██┌──┘██│  ██│██│   ██│██┌──██┐██┌────┘██┌──██┐██┌──██┐└██┐ ██┌┘",
    "   ██│   ███████│██│   ██│██████┌┘███████┐██│  ██│███████│ └████┌┘ ",
    "   ██│   ██┌──██│██│   ██│██┌──██┐└────██│██│  ██│██┌──██│  └██┌┘  ",
    "   ██│   ██│  ██│└██████┌┘██│  ██│███████│██████┌┘██│  ██│   ██│   ",
    "   └─┘   └─┘  └─┘ └─────┘ └─┘  └─┘└──────┘└─────┘ └─┘  └─┘   └─┘   ",
  },
  {
    "███████┐██████┐ ██┐██████┐  █████┐ ██┐   ██┐",
    "██┌────┘██┌──██┐██│██┌──██┐██┌──██┐└██┐ ██┌┘",
    "█████┐  ██████┌┘██│██│  ██│███████│ └████┌┘ ",
    "██┌──┘  ██┌──██┐██│██│  ██│██┌──██│  └██┌┘  ",
    "██│     ██│  ██│██│██████┌┘██│  ██│   ██│   ",
    "└─┘     └─┘  └─┘└─┘└─────┘ └─┘  └─┘   └─┘   ",
  },
  {
    "███████┐ █████┐ ████████┐██┐   ██┐██████┐ ██████┐  █████┐ ██┐   ██┐",
    "██┌────┘██┌──██┐└──██┌──┘██│   ██│██┌──██┐██┌──██┐██┌──██┐└██┐ ██┌┘",
    "███████┐███████│   ██│   ██│   ██│██████┌┘██│  ██│███████│ └████┌┘ ",
    "└────██│██┌──██│   ██│   ██│   ██│██┌──██┐██│  ██│██┌──██│  └██┌┘  ",
    "███████│██│  ██│   ██│   └██████┌┘██│  ██│██████┌┘██│  ██│   ██│   ",
    "└──────┘└─┘  └─┘   └─┘    └─────┘ └─┘  └─┘└─────┘ └─┘  └─┘   └─┘   ",
  },
  {
    "███████┐██┐   ██┐███┐   ██┐██████┐  █████┐ ██┐   ██┐",
    "██┌────┘██│   ██│████┐  ██│██┌──██┐██┌──██┐└██┐ ██┌┘",
    "███████┐██│   ██│██┌██┐ ██│██│  ██│███████│ └████┌┘ ",
    "└────██│██│   ██│██│└██┐██│██│  ██│██┌──██│  └██┌┘  ",
    "███████│└██████┌┘██│ └████│██████┌┘██│  ██│   ██│   ",
    "└──────┘ └─────┘ └─┘  └───┘└─────┘ └─┘  └─┘   └─┘   ",
  },
}

---@return string[]
function M.get()
  local weekday = tonumber(os.date "%w")
  if weekday == 0 then
    weekday = 7
  end

  return data[weekday]
end

return M
