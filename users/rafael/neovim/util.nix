{ lib, ... }:
let
  insertPCall = (
    label: body: /* lua */ ''
      -- ${label} --
      xpcall(function()
      ${
        (lib.pipe body [
          (s: lib.splitString "\n" s) # Break body into lines
          (ss: lib.map (str: ("\t" + str)) ss) # Indent lines right with a tab character
          (ss: lib.map (str: lib.strings.trimWith { end = true; } str) ss) # Trim whitespace of empty lines
          (ss: lib.concatStringsSep "\n" ss) # Join lines again into single string
        ])
      }
      end, function(err) vim.notify("FAILED TO LOAD '${label}': " .. err, vim.log.levels.ERROR) end)
    ''
  );

  insertChunk = (
    file:
    (lib.pipe file [
      builtins.readFile
      (s: insertPCall (baseNameOf file) s)
    ])
  );

  insertChunks = (
    files:
    lib.foldr (
      file: cfg:
      (lib.concatStringsSep "\n" [
        (insertChunk file)
        cfg
      ])
    ) "" files
  );
in
{
  inherit insertPCall insertChunk insertChunks;
}
