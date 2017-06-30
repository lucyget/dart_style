// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'alignment.dart';
import 'fast_hash.dart';
import 'nesting_level.dart';

class AlignedNestingLevel extends FastHash implements NestingLevel {
  final NestingLevel parent;

  final Alignment alignment;

  int get totalUsedIndent => _totalUsedIndent;
  int _totalUsedIndent;

  bool get isIndented => true;
  bool get isNested => true;
  final bool withParent;

  AlignedNestingLevel(this.parent, this.alignment, bool withParent)
      : withParent = withParent ?? false;

  /// Creates a new deeper level of nesting indented [spaces] more characters
  /// that the outer level.
  NestingLevel nest(int spaces, {bool withParent}) => new NestingLevel.nested(this, spaces, withParent);

  NestingLevel align(Alignment alignment, {bool withParent}) =>
      new AlignedNestingLevel(this, alignment, withParent);

  bool mayMatchNesting(NestingLevel other) => true;

  /// Clears the previously calculated total indent of this nesting level.
  void clearTotalUsedIndent() {
    _totalUsedIndent = null;
    parent.clearTotalUsedIndent();
  }

  void refreshTotalUsedIndent(Set<NestingLevel> usedNesting) {
    if (_totalUsedIndent != null) return;

    parent.refreshTotalUsedIndent(usedNesting);

    _totalUsedIndent = usedNesting.contains(this) ? alignment.depth : parent.totalUsedIndent;
  }

  String toString() => "$parent:aligned";
}
