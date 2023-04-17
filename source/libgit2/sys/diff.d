/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2.sys.diff;


private static import libgit2.diff;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/sys/diff.h
 * @brief Low-level Git diff utilities
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
package(libgit2):

/**
 * Diff print callback that writes to a git_buf.
 *
 * This function is provided not for you to call it directly, but instead
 * so you can use it as a function pointer to the `git_diff_print` or
 * `git_patch_print` APIs.  When using those APIs, you specify a callback
 * to actually handle the diff and/or patch data.
 *
 * Use this callback to easily write that data to a `git_buf` buffer.  You
 * must pass a `git_buf *` value as the payload to the `git_diff_print`
 * and/or `git_patch_print` function.  The data will be appended to the
 * buffer (after any existing content).
 */
@GIT_EXTERN
/*< payload must be a `git_buf *` */
int git_diff_print_callback__to_buf(const (libgit2.diff.git_diff_delta)* delta, const (libgit2.diff.git_diff_hunk)* hunk, const (libgit2.diff.git_diff_line)* line, void* payload);

/**
 * Diff print callback that writes to stdio FILE handle.
 *
 * This function is provided not for you to call it directly, but instead
 * so you can use it as a function pointer to the `git_diff_print` or
 * `git_patch_print` APIs.  When using those APIs, you specify a callback
 * to actually handle the diff and/or patch data.
 *
 * Use this callback to easily write that data to a stdio FILE handle.  You
 * must pass a `FILE *` value (such as `stdout` or `stderr` or the return
 * value from `fopen()`) as the payload to the `git_diff_print`
 * and/or `git_patch_print` function.  If you pass null, this will write
 * data to `stdout`.
 */
@GIT_EXTERN
/*< payload must be a `FILE *` */
int git_diff_print_callback__to_file_handle(const (libgit2.diff.git_diff_delta)* delta, const (libgit2.diff.git_diff_hunk)* hunk, const (libgit2.diff.git_diff_line)* line, void* payload);

/**
 * Performance data from diffing
 */
struct git_diff_perfdata
{
	uint version_;

	/**
	 * Number of stat() calls performed
	 */
	size_t stat_calls;

	/**
	 * Number of ID calculations
	 */
	size_t oid_calculations;
}

enum GIT_DIFF_PERFDATA_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_diff_perfdata GIT_DIFF_PERFDATA_INIT()

	do
	{
		.git_diff_perfdata OUTPUT =
		{
			version_: .GIT_DIFF_PERFDATA_VERSION,
			stat_calls: 0,
			oid_calculations: 0,
		};

		return OUTPUT;
	}

/**
 * Get performance data for a diff object.
 *
 * Params:
 *      out_ = Structure to be filled with diff performance data
 *      diff = Diff to read performance data from
 *
 * Returns: 0 for success, <0 for error
 */
@GIT_EXTERN
int git_diff_get_perfdata(.git_diff_perfdata* out_, const (libgit2.diff.git_diff)* diff);

/**
 * Get performance data for diffs from a git_status_list
 */
@GIT_EXTERN
int git_status_list_get_perfdata(.git_diff_perfdata* out_, const (libgit2.types.git_status_list)* status);

/* @} */
