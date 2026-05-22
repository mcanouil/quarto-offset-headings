--- Offset Headings - Filter
--- @module "offset-headings"
--- @license MIT License
--- @copyright 2026 Mickaël Canouil
--- @author Mickaël Canouil
--- @version 0.0.0
--- @brief Offset heading levels by a positive or negative amount, format-agnostic.
--- @description
---   Adjusts heading levels anywhere in a document, in any output format.
---
---   Document-level option (front matter, _quarto.yml, or _metadata.yml):
---
---     extensions:
---       offset-headings:
---         offset-headings-by: 1
---
---   Applies the offset to every heading in the document.
---
---   Per-heading attributes (override or supplement the document-level offset):
---
---     - `offset-headings-by` (integer, required on the heading): amount added
---       to the heading level. Positive values push the heading deeper;
---       negative values pull it up. The result is clamped to [1, 6].
---
---     - `offset-headings-recursive` (boolean, optional, default false): when
---       true, every following descendant heading (deeper than this heading's
---       original level) receives the same offset. Cascading stops as soon as a
---       heading at or above the base level is encountered. When false, only the
---       heading carrying the attribute is offset.
---
---   Both attributes are stripped from the output.
---
---   Usage:
---     ## Section {offset-headings-by="1"}
---       Produces a level-3 heading; descendant headings are unaffected.
---
---     ## Section {offset-headings-by="1" offset-headings-recursive="true"}
---       Produces a level-3 heading; every nested heading also shifts by 1.

--- Extension name constant
local EXTENSION_NAME = 'offset-headings'

local log = require(quarto.utils.resolve_path('_modules/logging.lua'):gsub('%.lua$', ''))
local meta_utils = require(quarto.utils.resolve_path('_modules/metadata.lua'):gsub('%.lua$', ''))

local OFFSET_ATTRIBUTE = 'offset-headings-by'
local RECURSIVE_ATTRIBUTE = 'offset-headings-recursive'

local MIN_LEVEL = 1
local MAX_LEVEL = 6

--- Document-level offset applied to every heading.
local document_offset = 0

--- Clamp a heading level to the valid Pandoc range [1, 6].
--- @param level number The desired heading level.
--- @return number The level clamped to [MIN_LEVEL, MAX_LEVEL].
local function clamp_level(level)
  return math.max(MIN_LEVEL, math.min(MAX_LEVEL, level))
end

--- Parse a string into an integer offset.
--- @param raw string|nil The raw attribute value.
--- @return number|nil The integer offset, or nil when not a number.
local function parse_offset(raw)
  if raw == nil then
    return nil
  end
  local value = tonumber(raw)
  if value == nil then
    return nil
  end
  return math.floor(value)
end

--- Parse a string into a boolean (default false).
--- @param raw string|nil The raw attribute value.
--- @return boolean True when the value is a truthy token.
local function parse_boolean(raw)
  if raw == nil then
    return false
  end
  local value = tostring(raw):lower()
  return value == 'true' or value == 'yes' or value == '1'
end

--- Read the document-level offset from extension metadata.
--- @param meta table The document metadata.
--- @return table The unmodified metadata.
local function read_metadata(meta)
  local raw = meta_utils.get_metadata_value(meta, EXTENSION_NAME, OFFSET_ATTRIBUTE)
  local offset = parse_offset(raw)
  if raw ~= nil and offset == nil then
    log.log_warning(EXTENSION_NAME, 'Ignoring non-integer "' .. OFFSET_ATTRIBUTE .. '": "' .. raw .. '".')
    offset = 0
  end
  document_offset = offset or 0
  return meta
end

--- Offset heading levels across the whole document in reading order.
--- Processing the block sequence is required to support recursive cascading.
--- @param doc pandoc.Pandoc The full document.
--- @return pandoc.Pandoc The document with heading levels adjusted.
local function process_pandoc(doc)
  local cascade_offset = nil
  local cascade_base_level = nil

  doc.blocks = doc.blocks:walk({
    Header = function(header)
      local original_level = header.level
      local raw_offset = header.attributes[OFFSET_ATTRIBUTE]

      if raw_offset ~= nil then
        local offset = parse_offset(raw_offset)
        header.attributes[OFFSET_ATTRIBUTE] = nil
        local recursive = parse_boolean(header.attributes[RECURSIVE_ATTRIBUTE])
        header.attributes[RECURSIVE_ATTRIBUTE] = nil

        if offset == nil then
          log.log_warning(
            EXTENSION_NAME,
            'Ignoring non-integer "' .. OFFSET_ATTRIBUTE .. '": "' .. raw_offset .. '".'
          )
          header.level = clamp_level(original_level + document_offset)
          cascade_offset = nil
          cascade_base_level = nil
        else
          header.level = clamp_level(original_level + document_offset + offset)
          if recursive then
            cascade_offset = offset
            cascade_base_level = original_level
          else
            cascade_offset = nil
            cascade_base_level = nil
          end
        end
      elseif cascade_offset ~= nil and original_level <= cascade_base_level then
        -- Sibling or ancestor: stop cascading and apply only the document offset.
        cascade_offset = nil
        cascade_base_level = nil
        header.level = clamp_level(original_level + document_offset)
      elseif cascade_offset ~= nil then
        -- Descendant within the active cascade: apply document and cascade offsets.
        header.level = clamp_level(original_level + document_offset + cascade_offset)
      else
        header.level = clamp_level(original_level + document_offset)
      end

      return header
    end,
  })

  return doc
end

return {
  { Meta = read_metadata },
  { Pandoc = process_pandoc }
}
