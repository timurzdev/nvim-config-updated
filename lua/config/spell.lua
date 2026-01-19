vim.opt.spell = true

local state_path = vim.fn.stdpath("state") .. "/spell_lang"
local default_lang = "en_us"

local function read_spell_language()
  local handle = io.open(state_path, "r")
  if not handle then
    return default_lang
  end

  local value = handle:read("*l")
  handle:close()

  if value and value ~= "" then
    return value
  end

  return default_lang
end

local function write_spell_language(value)
  local state_dir = vim.fn.stdpath("state")
  vim.fn.mkdir(state_dir, "p")

  local handle = io.open(state_path, "w")
  if not handle then
    vim.notify("Failed to persist spell language", vim.log.levels.WARN)
    return
  end

  handle:write(value)
  handle:close()
end

local function ensure_russian_dictionary()
  local spell_dir = vim.fn.stdpath("config") .. "/spell"
  local ru_spl = spell_dir .. "/ru.utf-8.spl"
  local ru_sug = spell_dir .. "/ru.utf-8.sug"

  local function exists(path)
    return vim.uv.fs_stat(path) ~= nil
  end

  if exists(ru_spl) and exists(ru_sug) then
    return
  end

  if vim.fn.executable("curl") ~= 1 then
    vim.notify("curl not found; can't download Russian spell files", vim.log.levels.WARN)
    return
  end

  vim.fn.mkdir(spell_dir, "p")

  local function download(url, destination)
    if vim.system then
      vim.system({ "curl", "-fLo", destination, url }, {}, function(result)
        if result.code ~= 0 then
          vim.schedule(function()
            vim.notify("Failed to download " .. url, vim.log.levels.WARN)
          end)
        end
      end)
    else
      local output = vim.fn.system({ "curl", "-fLo", destination, url })
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to download " .. url .. ": " .. output, vim.log.levels.WARN)
      end
    end
  end

  if not exists(ru_spl) then
    download("https://ftp.nluug.nl/pub/vim/runtime/spell/ru.utf-8.spl", ru_spl)
  end

  if not exists(ru_sug) then
    download("https://ftp.nluug.nl/pub/vim/runtime/spell/ru.utf-8.sug", ru_sug)
  end
end

vim.opt.spelllang = read_spell_language()
ensure_russian_dictionary()

local function toggle_spell_language()
  local current = vim.bo.spelllang
  if current:match("ru") then
    vim.bo.spelllang = "en_us"
  else
    vim.bo.spelllang = "ru"
  end

  write_spell_language(vim.bo.spelllang)
  vim.notify("Spell language: " .. vim.bo.spelllang)
end

vim.keymap.set("n", "<leader>ts", toggle_spell_language, { desc = "Toggle [S]pell language" })
