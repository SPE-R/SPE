-- Pandoc lua filter for SPE-R solution/exercise fenced divs.
--
-- In a .rmd file, faculty can wrap a multi-line block as either:
--
--     ::: solution
--     Extra explanation that appears only in the solutions book.
--     :::
--
--     ::: exercise
--     "Fill in the code below" stub that appears only in the exercise book.
--     :::
--
-- This filter strips or keeps each div based on the SPE_SOLUTIONS
-- environment variable, mirroring the dispatch used by _common.R for
-- inline helpers and chunk options.

local solutions = os.getenv("SPE_SOLUTIONS") == "1"

local function has_class(el, name)
  for _, c in ipairs(el.classes) do
    if c == name then return true end
  end
  return false
end

function Div(el)
  if has_class(el, "solution") then
    if solutions then return el.content else return {} end
  end
  if has_class(el, "exercise") then
    if solutions then return {} else return el.content end
  end
end
