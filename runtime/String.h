#ifndef RUNTIME_STRING_H
#define RUNTIME_STRING_H

#include "RuntimeTypes.h"

/**ﬂ
 * Set of built-in functions related to string management.
 */

extern "C" stark::int_t stark_runtime_priv_conv_string_int(stark::string_t *s);

extern "C" stark::double_t stark_runtime_priv_conv_string_double(stark::string_t *s);

extern "C" stark::bool_t stark_runtime_priv_conv_string_bool(stark::string_t *s);

extern "C" stark::string_t *stark_runtime_priv_concat_string(stark::string_t *ls, stark::string_t *rs);

extern "C" stark::bool_t stark_runtime_priv_eq_string(stark::string_t *ls, stark::string_t *rs);

extern "C" stark::bool_t stark_runtime_priv_neq_string(stark::string_t *ls, stark::string_t *rs);

#endif