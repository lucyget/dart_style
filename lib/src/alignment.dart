// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'chunk.dart';

class Alignment {
  Chunk _chunk;

  int _extraDepth;

  int get depth => _chunk.depth + _extraDepth;

  void finalize(Chunk chunk, [int extraDepth]) {
    assert(_chunk == null);
    _chunk = chunk;
    _extraDepth = extraDepth ?? 0;
  }
}
