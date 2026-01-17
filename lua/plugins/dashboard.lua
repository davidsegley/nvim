return {
  "goolord/alpha-nvim",
  dependencies = { "echasnovski/mini.icons" },
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.startify")
    local logo = [[
  _____________________________________
/ There are no regrets. If one can be \
| proud of one's life, one should not |
\ wish for another chance.            /
 -------------------------------------
\                             .       .
 \                           / `.   .' "
  \                  .---.  <    > <    >  .---.
   \                 |    \  \ - ~ ~ - /  /    |
         _____          ..-~             ~-..-~
        |     |   \~~~\.'                    `./~~~/
       ---------   \__/                        \__/
      .'  O    \     /               /       \  "
     (_____,    `._.'               |         }  \/~~~/
      `----.          /       }     |        /    \__/
            `-.      |       /      |       /      `. ,~~|
                ~-.__|      /_ - ~ ^|      /- _      `..-'
                     |     /        |     /     ~-.     `-. _  _  _
                     |_____|        |_____|         ~ - . _ _ _ _ _>
    ]]
    dashboard.section.header.val = vim.split(logo, "\n")
    alpha.setup(dashboard.opts)
  end,
}
