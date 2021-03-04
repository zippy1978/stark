/**
 * Comparison expressions tests.
 */

extern assertTrue(actual: bool): void
extern assertFalse(actual: bool): void

// Equal
assertTrue(1 == 1)
assertTrue(2.5 == 2.5)

// Not equal
assertTrue(1 != 2)
assertTrue(2.5 != 4.5)

// Greater than
assertTrue(2 > 1)
assertTrue(2.5 > 1.5)

// Greater or equal
assertTrue(2 >= 2)
assertTrue(2.5 >= 2.5)

// Lower than
assertTrue(1 < 2)
assertTrue(1.5 < 2.5)

// Lower or equal
assertTrue(2 <= 2)
assertTrue(2.5 <= 2.5)

// Null comparison
s: string = null
assertTrue(s == null)
assertTrue(null == s)
s = "not null"
assertTrue(s != null)
assertTrue(null != s)
