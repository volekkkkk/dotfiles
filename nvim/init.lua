--[[ 
 Vanilla parameters 
]]
vim.opt.number = true
vim.opt.signcolumn = "yes"

--vim.cmd("language en_US")

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4   
vim.opt.smarttab = true
-- vim.opt.expandtab = true
-- vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.listchars = { eol = '↲', tab = '▸ ', trail = '~', space = '·' }
-- vim.opt.list = true

vim.wo.wrap = false

vim.filetype.add({
	extension = {
		["inc"] = "c",
	}
})


--[[
 Lazy setup
]]

-- Lazy bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		'romgrk/barbar.nvim',
		dependencies = 'nvim-tree/nvim-web-devicons',
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		config = function()
			vim.cmd([[
				colorscheme catppuccin-mocha
				highlight NormalNC guibg=NONE
				highlight NormalSB guibg=NONE 
				highlight Normal guibg=NONE
				highlight NvimTreeNormal guibg=NONE
				highlight NvimTreeWinSeparator guibg=NONE guifg=#232634
			]])
		end,
	},
	{ "lukas-reineke/indent-blankline.nvim" },
	{ "lukas-reineke/lsp-format.nvim" },
	{
		"m4xshen/smartcolumn.nvim",
		config = function()
			require("smartcolumn").setup({ colorcolumn = { "80", "100" } })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function() require("gitsigns").setup() end,
	},
	{ "neovim/nvim-lspconfig" },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			highlight = { enable = true },
			ensure_installed = {
				"c",
				"cpp",
				"cmake",
				"make",
				"lua",
				"python",
				"query",
				"ruby",
				"vim",
				"yaml",
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{ "luukvbaal/statuscol.nvim" },
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup {
				padding = false,
			}
			vim.api.nvim_set_keymap("n", "<C-m>", ":TroubleToggle<cr>", {silent = true, noremap = true})
		end
	},
	{ "f-person/git-blame.nvim" },
	{ "fatih/vim-go" },
	{ 
		"hrsh7th/nvim-cmp", -- autocomplection
		dependencies = {
		    "hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip"
		}
	}
})


--[[
 nvim-tree setup
]]
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})

local function tab_win_closed(winnr)
	local api = require("nvim-tree.api")
	local tabnr = vim.api.nvim_win_get_tabpage(winnr)
	local bufnr = vim.api.nvim_win_get_buf(winnr)
	local buf_info = vim.fn.getbufinfo(bufnr)[1]
	local tab_wins = vim.tbl_filter(
		function(w) return w~=winnr end,
		vim.api.nvim_tabpage_list_wins(tabnr)
	)
	local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
	if buf_info.name:match(".*NvimTree_%d*$") then            -- close buffer was nvim tree
    -- Close all nvim tree on :q
		if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below)
			api.tree.close()
		end
	else                                                      -- else closed buffer was normal buffer
		if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab
			local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
			if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree
				vim.schedule(function ()
					if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim
						vim.cmd "quit"                                        -- then close all of vim
					else                                                  -- else there are more tabs open
						vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab
					end
				end)
			end
		end
	end
end

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function ()
    local winnr = tonumber(vim.fn.expand("<amatch>"))
    vim.schedule_wrap(tab_win_closed(winnr))
  end,
  nested = true
})

require("nvim-tree").setup {
	renderer = {
		indent_markers = { enable = true },
	},
	filters = { dotfiles = true },
}


--[[
 lualine setup
]]
vim.opt.laststatus = 3

require("lualine").setup {
	options = {
		--theme = "base16",
		section_separators = { left = '', right = '' },
		component_separators = { left = '', right = '' },
	},
	extensions = { "nvim-tree" },
}


--[[
 lsp-format setup
 ]]
require("lsp-format").setup {}

local capabilities = require("cmp_nvim_lsp").default_capabilities()


--[[
 lspconfig setup
]]
local lspconfig = require("lspconfig")

lspconfig.pylsp.setup {
	settings = {
		pylsp = {
			plugins = {
				pylint = { enabled = false },
				black = { enabled = true },
				pylsp_mypy = { enabled = true },
				ruff = { enabled = true },
			},
		},
	},
	capabilities = capabilities,
	on_attach = require("lsp-format").on_attach
}

lspconfig.clangd.setup {
	cmd = {
		"clangd",
	    capabilities = capabilities,
	}
}

lspconfig.gopls.setup{ 
	capabilities = capabilities
}

lspconfig.jsonls.setup{
	capabilities = capabilities
}

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

vim.diagnostic.config({virtual_text = false})

local signs = {
    Error = "",
    Warn = "",
    Hint = "",
    Info = ""
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, --[[numhl = hl]] })
end


--[[
 ufo setup
]]
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,foldopen:,foldclose:]]

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ('  %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

require("ufo").setup({
    provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
    end,
	fold_virt_text_handler = handler,
})

--[[
 statuscol setup
]]
local builtin = require("statuscol.builtin")
require("statuscol").setup({
	segments = {
		{ text = { "%s" }, click = "v:lua.ScSa" },
		{ text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
		{
			text = { " ", builtin.foldfunc, " " },
			condition = { builtin.not_empty, true, builtin.not_empty },
			click = "v:lua.ScFa"
		},
	}
})
