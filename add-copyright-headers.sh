#!/bin/bash
read -r -d '' license <<-"EOF"
/*
 * Copyright 2021 Gilles Grousset. All rights reserved.
 * Use of this source code is governed by MIT license that can be
 * found in the LICENSE file.
 */
EOF

files=$(grep -rL "Copyright 2021 Gilles Grousset. All rights reserved." * | grep "\.h\|\.cpp")

for f in $files
do
  echo -e "$license" > temp  
  cat $f >> temp
  mv temp $f
done