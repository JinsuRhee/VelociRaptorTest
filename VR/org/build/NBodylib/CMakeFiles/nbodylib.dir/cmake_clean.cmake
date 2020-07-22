file(REMOVE_RECURSE
  "libnbodylib.pdb"
  "libnbodylib.a"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/nbodylib.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
