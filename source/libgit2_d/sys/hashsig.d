/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.sys.hashsig;


extern (C):
nothrow @nogc:
package(libgit2_d):

/**
 * Similarity signature of arbitrary text content based on line hashes
 */
struct git_hashsig;

/**
 * Options for hashsig computation
 *
 * The options GIT_HASHSIG_NORMAL, GIT_HASHSIG_IGNORE_WHITESPACE,
 * GIT_HASHSIG_SMART_WHITESPACE are exclusive and should not be combined.
 */
enum git_hashsig_option_t
{
	/**
	 * Use all data
	 */
	GIT_HASHSIG_NORMAL = 0,

	/**
	 * Ignore whitespace
	 */
	GIT_HASHSIG_IGNORE_WHITESPACE = 1 << 0,

	/**
	 * Ignore \r and all space after \n
	 */
	GIT_HASHSIG_SMART_WHITESPACE = 1 << 1,

	/**
	 * Allow hashing of small files
	 */
	GIT_HASHSIG_ALLOW_SMALL_FILES = 1 << 2,
}

//Declaration name in C language
enum
{
	GIT_HASHSIG_NORMAL = .git_hashsig_option_t.GIT_HASHSIG_NORMAL,
	GIT_HASHSIG_IGNORE_WHITESPACE = .git_hashsig_option_t.GIT_HASHSIG_IGNORE_WHITESPACE,
	GIT_HASHSIG_SMART_WHITESPACE = .git_hashsig_option_t.GIT_HASHSIG_SMART_WHITESPACE,
	GIT_HASHSIG_ALLOW_SMALL_FILES = .git_hashsig_option_t.GIT_HASHSIG_ALLOW_SMALL_FILES,
}

/**
 * Compute a similarity signature for a text buffer
 *
 * If you have passed the option git_hashsig_option_t.GIT_HASHSIG_IGNORE_WHITESPACE, then the
 * whitespace will be removed from the buffer while it is being processed,
 * modifying the buffer in place. Sorry about that!
 *
 * Params:
 *      out_ = The computed similarity signature.
 *      buf = The input buffer.
 *      buflen = The input buffer size.
 *      opts = The signature computation options (see above).
 *
 * Returns: 0 on success, git_error_code.GIT_EBUFS if the buffer doesn't contain enough data to compute a valid signature (unless git_hashsig_option_t.GIT_HASHSIG_ALLOW_SMALL_FILES is set), or error code.
 */
//GIT_EXTERN
int git_hashsig_create(.git_hashsig** out_, const (char)* buf, size_t buflen, .git_hashsig_option_t opts);

/**
 * Compute a similarity signature for a text file
 *
 * This walks through the file, only loading a maximum of 4K of file data at
 * a time. Otherwise, it acts just like `git_hashsig_create`.
 *
 * Params:
 *      out_ = The computed similarity signature.
 *      path = The path to the input file.
 *      opts = The signature computation options (see above).
 *
 * Returns: 0 on success, git_error_code.GIT_EBUFS if the buffer doesn't contain enough data to compute a valid signature (unless git_hashsig_option_t.GIT_HASHSIG_ALLOW_SMALL_FILES is set), or error code.
 */
//GIT_EXTERN
int git_hashsig_create_fromfile(.git_hashsig** out_, const (char)* path, .git_hashsig_option_t opts);

/**
 * Release memory for a content similarity signature
 *
 * Params:
 *      sig = The similarity signature to free.
 */
//GIT_EXTERN
void git_hashsig_free(.git_hashsig* sig);

/**
 * Measure similarity score between two similarity signatures
 *
 * Params:
 *      a = The first similarity signature to compare.
 *      b = The second similarity signature to compare.
 *
 * Returns: [0 to 100] on success as the similarity score, or error code.
 */
//GIT_EXTERN
int git_hashsig_compare(const (.git_hashsig)* a, const (.git_hashsig)* b);
