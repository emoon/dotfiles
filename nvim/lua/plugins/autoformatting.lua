return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")
        local sources = {
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.clang_format.with({ extra_args = { "--style=file" } }),
        }

        vim.keymap.set("n", "<leader>fo", vim.lsp.buf.format, {})

        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        null_ls.setup({
            -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
            sources = sources,
            -- you can reuse a shared lspconfig on_attach callback here
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end
            end,
        })
    end,
}
