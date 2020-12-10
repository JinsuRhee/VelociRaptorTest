file(REMOVE_RECURSE
  "libnbodylib.a"
  "libnbodylib.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/nbodylib.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
