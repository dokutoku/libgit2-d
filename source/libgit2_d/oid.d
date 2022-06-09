/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.oid;


/*
 * @file git2/oid.h
 * @brief Git object id routines
 * @defgroup git_oid Git object id routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Size (in bytes) of a raw/binary oid
 */
enum GIT_OID_RAWSZ = 20;

/**
 * Size (in bytes) of a hex formatted oid
 */
enum GIT_OID_HEXSZ = .GIT_OID_RAWSZ * 2;

/**
 * Minimum length (in number of hex characters,
 * i.e. packets of 4 bits) of an oid prefix
 */
enum GIT_OID_MINPREFIXLEN = 4;

/**
 * Unique identity of any object (commit, tree, blob, tag).
 */
struct git_oid
{
	/**
	 * raw binary formatted id
	 */
	ubyte[.GIT_OID_RAWSZ] id;
}

/**
 * Parse a hex formatted object id into a git_oid.
 *
 * Params:
 *      out_ = oid structure the result is written into.
 *      str = input hex string; must be pointing at the start of the hex sequence and have at least the number of bytes needed for an oid encoded in hex (40 bytes).
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_oid_fromstr(.git_oid* out_, const (char)* str);

/**
 * Parse a hex formatted null-terminated string into a git_oid.
 *
 * Params:
 *      out_ = oid structure the result is written into.
 *      str = input hex string; must be null-terminated.
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_oid_fromstrp(.git_oid* out_, const (char)* str);

/**
 * Parse N characters of a hex formatted object id into a git_oid.
 *
 * If N is odd, the last byte's high nibble will be read in and the
 * low nibble set to zero.
 *
 * Params:
 *      out_ = oid structure the result is written into.
 *      str = input hex string of at least size `length`
 *      length = length of the input string
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_oid_fromstrn(.git_oid* out_, const (char)* str, size_t length);

/**
 * Copy an already raw oid into a git_oid structure.
 *
 * Params:
 *      out_ = oid structure the result is written into.
 *      raw = the raw input bytes to be copied.
 *
 * Returns: 0 on success or error code
 */
//GIT_EXTERN
int git_oid_fromraw(.git_oid* out_, const (ubyte)* raw);

/**
 * Format a git_oid into a hex string.
 *
 * Params:
 *      out_ = output hex string; must be pointing at the start of the hex sequence and have at least the number of bytes needed for an oid encoded in hex (40 bytes). Only the oid digits are written; a '\\0' terminator must be added by the caller if it is required.
 *      id = oid structure to format.
 *
 * Returns: 0 on success or error code
 */
//GIT_EXTERN
int git_oid_fmt(char* out_, const (.git_oid)* id);

/**
 * Format a git_oid into a partial hex string.
 *
 * Params:
 *      out_ = output hex string; you say how many bytes to write. If the number of bytes is > GIT_OID_HEXSZ, extra bytes will be zeroed; if not, a '\0' terminator is NOT added.
 *      n = number of characters to write into out string
 *      id = oid structure to format.
 *
 * Returns: 0 on success or error code
 */
//GIT_EXTERN
int git_oid_nfmt(char* out_, size_t n, const (.git_oid)* id);

/**
 * Format a git_oid into a loose-object path string.
 *
 * The resulting string is "aa/...", where "aa" is the first two
 * hex digits of the oid and "..." is the remaining 38 digits.
 *
 * Params:
 *      out_ = output hex string; must be pointing at the start of the hex sequence and have at least the number of bytes needed for an oid encoded in hex (41 bytes). Only the oid digits are written; a '\\0' terminator must be added by the caller if it is required.
 *      id = oid structure to format.
 *
 * Returns: 0 on success, non-zero callback return value, or error code
 */
//GIT_EXTERN
int git_oid_pathfmt(char* out_, const (.git_oid)* id);

/**
 * Format a git_oid into a statically allocated c-string.
 *
 * The c-string is owned by the library and should not be freed
 * by the user. If libgit2 is built with thread support, the string
 * will be stored in TLS (i.e. one buffer per thread) to allow for
 * concurrent calls of the function.
 *
 * Params:
 *      oid = The oid structure to format
 *
 * Returns: the c-string
 */
//GIT_EXTERN
char* git_oid_tostr_s(const (.git_oid)* oid);

/**
 * Format a git_oid into a buffer as a hex format c-string.
 *
 * If the buffer is smaller than GIT_OID_HEXSZ+1, then the resulting
 * oid c-string will be truncated to n-1 characters (but will still be
 * NUL-byte terminated).
 *
 * If there are any input parameter errors (out == null, n == 0, oid ==
 * null), then a pointer to an empty string is returned, so that the
 * return value can always be printed.
 *
 * Params:
 *      out_ = the buffer into which the oid string is output.
 *      n = the size of the out buffer.
 *      id = the oid structure to format.
 *
 * Returns: the out buffer pointer, assuming no input parameter errors, otherwise a pointer to an empty string.
 */
//GIT_EXTERN
char* git_oid_tostr(char* out_, size_t n, const (.git_oid)* id);

/**
 * Copy an oid from one structure to another.
 *
 * Params:
 *      out_ = oid structure the result is written into.
 *      src = oid structure to copy from.
 *
 * Returns: 0 on success or error code
 */
//GIT_EXTERN
int git_oid_cpy(.git_oid* out_, const (.git_oid)* src);

/**
 * Compare two oid structures.
 *
 * Params:
 *      a = first oid structure.
 *      b = second oid structure.
 *
 * Returns: <0, 0, >0 if a < b, a == b, a > b.
 */
//GIT_EXTERN
int git_oid_cmp(const (.git_oid)* a, const (.git_oid)* b);

/**
 * Compare two oid structures for equality
 *
 * Params:
 *      a = first oid structure.
 *      b = second oid structure.
 *
 * Returns: true if equal, false otherwise
 */
//GIT_EXTERN
int git_oid_equal(const (.git_oid)* a, const (.git_oid)* b);

/**
 * Compare the first 'len' hexadecimal characters (packets of 4 bits)
 * of two oid structures.
 *
 * Params:
 *      a = first oid structure.
 *      b = second oid structure.
 *      len = the number of hex chars to compare
 *
 * Returns: 0 in case of a match
 */
//GIT_EXTERN
int git_oid_ncmp(const (.git_oid)* a, const (.git_oid)* b, size_t len);

/**
 * Check if an oid equals an hex formatted object id.
 *
 * Params:
 *      id = oid structure.
 *      str = input hex string of an object id.
 *
 * Returns: 0 in case of a match, -1 otherwise.
 */
//GIT_EXTERN
int git_oid_streq(const (.git_oid)* id, const (char)* str);

/**
 * Compare an oid to an hex formatted object id.
 *
 * Params:
 *      id = oid structure.
 *      str = input hex string of an object id.
 *
 * Returns: -1 if str is not valid, <0 if id sorts before str, 0 if id matches str, >0 if id sorts after str.
 */
//GIT_EXTERN
int git_oid_strcmp(const (.git_oid)* id, const (char)* str);

/**
 * Check is an oid is all zeros.
 *
 * Returns: 1 if all zeros, 0 otherwise.
 */
//GIT_EXTERN
int git_oid_is_zero(const (.git_oid)* id);

/**
 * OID Shortener object
 */
struct git_oid_shorten;

/**
 * Create a new OID shortener.
 *
 * The OID shortener is used to process a list of OIDs
 * in text form and return the shortest length that would
 * uniquely identify all of them.
 *
 * E.g. look at the result of `git log --abbrev`.
 *
 * Params:
 *      min_length = The minimal length for all identifiers, which will be used even if shorter OIDs would still be unique.
 *
 * Returns: a `git_oid_shorten` instance, null if OOM
 */
//GIT_EXTERN
.git_oid_shorten* git_oid_shorten_new(size_t min_length);

/**
 * Add a new OID to set of shortened OIDs and calculate
 * the minimal length to uniquely identify all the OIDs in
 * the set.
 *
 * The OID is expected to be a 40-char hexadecimal string.
 * The OID is owned by the user and will not be modified
 * or freed.
 *
 * For performance reasons, there is a hard-limit of how many
 * OIDs can be added to a single set (around ~32000, assuming
 * a mostly randomized distribution), which should be enough
 * for any kind of program, and keeps the algorithm fast and
 * memory-efficient.
 *
 * Attempting to add more than those OIDs will result in a
 * git_error_t.GIT_ERROR_INVALID error
 *
 * Params:
 *      os = a `git_oid_shorten` instance
 *      text_id = an OID in text form
 *
 * Returns: the minimal length to uniquely identify all OIDs added so far to the set; or an error code (<0) if an error occurs.
 */
//GIT_EXTERN
int git_oid_shorten_add(.git_oid_shorten* os, const (char)* text_id);

/**
 * Free an OID shortener instance
 *
 * Params:
 *      os = a `git_oid_shorten` instance
 */
//GIT_EXTERN
void git_oid_shorten_free(.git_oid_shorten* os);

/* @} */
