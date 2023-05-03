/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.patch;


private static import libgit2.buffer;
private static import libgit2.diff;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/patch.h
 * @brief Patch handling routines.
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * The diff patch is used to store all the text diffs for a delta.
 *
 * You can easily loop over the content of patches and get information about
 * them.
 */
struct git_patch;

/**
 * Return a patch for an entry in the diff list.
 *
 * The `git_patch` is a newly created object contains the text diffs
 * for the delta.  You have to call `git_patch_free()` when you are
 * done with it.  You can use the patch object to loop over all the hunks
 * and lines in the diff of the one delta.
 *
 * For an unchanged file or a binary file, no `git_patch` will be
 * created, the output will be set to null, and the `binary` flag will be
 * set true in the `git_diff_delta` structure.
 *
 * It is okay to pass null for either of the output parameters; if you pass
 * null for the `git_patch`, then the text diff will not be calculated.
 *
 * Params:
 *      out_ = Output parameter for the delta patch object
 *      diff = Diff list object
 *      idx = Index into diff list
 *
 * Returns: 0 on success, other value < 0 on error
 */
@GIT_EXTERN
int git_patch_from_diff(.git_patch** out_, libgit2.diff.git_diff* diff, size_t idx);

/**
 * Directly generate a patch from the difference between two blobs.
 *
 * This is just like `git_diff_blobs()` except it generates a patch object
 * for the difference instead of directly making callbacks.  You can use the
 * standard `git_patch` accessor functions to read the patch data, and
 * you must call `git_patch_free()` on the patch when done.
 *
 * Params:
 *      out_ = The generated patch; null on error
 *      old_blob = Blob for old side of diff, or null for empty blob
 *      old_as_path = Treat old blob as if it had this filename; can be null
 *      new_blob = Blob for new side of diff, or null for empty blob
 *      new_as_path = Treat new blob as if it had this filename; can be null
 *      opts = Options for diff, or null for default options
 *
 * Returns: 0 on success or error code < 0
 */
@GIT_EXTERN
int git_patch_from_blobs(.git_patch** out_, const (libgit2.types.git_blob)* old_blob, const (char)* old_as_path, const (libgit2.types.git_blob)* new_blob, const (char)* new_as_path, const (libgit2.diff.git_diff_options)* opts);

/**
 * Directly generate a patch from the difference between a blob and a buffer.
 *
 * This is just like `git_diff_blob_to_buffer()` except it generates a patch
 * object for the difference instead of directly making callbacks.  You can
 * use the standard `git_patch` accessor functions to read the patch
 * data, and you must call `git_patch_free()` on the patch when done.
 *
 * Params:
 *      out_ = The generated patch; null on error
 *      old_blob = Blob for old side of diff, or null for empty blob
 *      old_as_path = Treat old blob as if it had this filename; can be null
 *      buffer = Raw data for new side of diff, or null for empty
 *      buffer_len = Length of raw data for new side of diff
 *      buffer_as_path = Treat buffer as if it had this filename; can be null
 *      opts = Options for diff, or null for default options
 *
 * Returns: 0 on success or error code < 0
 */
@GIT_EXTERN
int git_patch_from_blob_and_buffer(.git_patch** out_, const (libgit2.types.git_blob)* old_blob, const (char)* old_as_path, const (void)* buffer, size_t buffer_len, const (char)* buffer_as_path, const (libgit2.diff.git_diff_options)* opts);

/**
 * Directly generate a patch from the difference between two buffers.
 *
 * This is just like `git_diff_buffers()` except it generates a patch
 * object for the difference instead of directly making callbacks.  You can
 * use the standard `git_patch` accessor functions to read the patch
 * data, and you must call `git_patch_free()` on the patch when done.
 *
 * Params:
 *      out_ = The generated patch; null on error
 *      old_buffer = Raw data for old side of diff, or null for empty
 *      old_len = Length of the raw data for old side of the diff
 *      old_as_path = Treat old buffer as if it had this filename; can be null
 *      new_buffer = Raw data for new side of diff, or null for empty
 *      new_len = Length of raw data for new side of diff
 *      new_as_path = Treat buffer as if it had this filename; can be null
 *      opts = Options for diff, or null for default options
 *
 * Returns: 0 on success or error code < 0
 */
@GIT_EXTERN
int git_patch_from_buffers(.git_patch** out_, const (void)* old_buffer, size_t old_len, const (char)* old_as_path, const (void)* new_buffer, size_t new_len, const (char)* new_as_path, const (libgit2.diff.git_diff_options)* opts);

/**
 * Free a git_patch object.
 */
@GIT_EXTERN
void git_patch_free(.git_patch* patch);

/**
 * Get the delta associated with a patch.  This delta points to internal
 * data and you do not have to release it when you are done with it.
 */
@GIT_EXTERN
const (libgit2.diff.git_diff_delta)* git_patch_get_delta(const (.git_patch)* patch);

/**
 * Get the number of hunks in a patch
 */
@GIT_EXTERN
size_t git_patch_num_hunks(const (.git_patch)* patch);

/**
 * Get line counts of each type in a patch.
 *
 * This helps imitate a diff --numstat type of output.  For that purpose,
 * you only need the `total_additions` and `total_deletions` values, but we
 * include the `total_context` line count in case you want the total number
 * of lines of diff output that will be generated.
 *
 * All outputs are optional. Pass null if you don't need a particular count.
 *
 * Params:
 *      total_context = Count of context lines in output, can be null.
 *      total_additions = Count of addition lines in output, can be null.
 *      total_deletions = Count of deletion lines in output, can be null.
 *      patch = The git_patch object
 *
 * Returns: 0 on success, <0 on error
 */
@GIT_EXTERN
int git_patch_line_stats(size_t* total_context, size_t* total_additions, size_t* total_deletions, const (.git_patch)* patch);

/**
 * Get the information about a hunk in a patch
 *
 * Given a patch and a hunk index into the patch, this returns detailed
 * information about that hunk.  Any of the output pointers can be passed
 * as null if you don't care about that particular piece of information.
 *
 * Params:
 *      out_ = Output pointer to git_diff_hunk of hunk
 *      lines_in_hunk = Output count of total lines in this hunk
 *      patch = Input pointer to patch object
 *      hunk_idx = Input index of hunk to get information about
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND if hunk_idx out of range, <0 on error
 */
@GIT_EXTERN
int git_patch_get_hunk(const (libgit2.diff.git_diff_hunk)** out_, size_t* lines_in_hunk, .git_patch* patch, size_t hunk_idx);

/**
 * Get the number of lines in a hunk.
 *
 * Params:
 *      patch = The git_patch object
 *      hunk_idx = Index of the hunk
 *
 * Returns: Number of lines in hunk or git_error_code.GIT_ENOTFOUND if invalid hunk index
 */
@GIT_EXTERN
int git_patch_num_lines_in_hunk(const (.git_patch)* patch, size_t hunk_idx);

/**
 * Get data about a line in a hunk of a patch.
 *
 * Given a patch, a hunk index, and a line index in the hunk, this
 * will return a lot of details about that line.  If you pass a hunk
 * index larger than the number of hunks or a line index larger than
 * the number of lines in the hunk, this will return -1.
 *
 * Params:
 *      out_ = The git_diff_line data for this line
 *      patch = The patch to look in
 *      hunk_idx = The index of the hunk
 *      line_of_hunk = The index of the line in the hunk
 *
 * Returns: 0 on success, <0 on failure
 */
@GIT_EXTERN
int git_patch_get_line_in_hunk(const (libgit2.diff.git_diff_line)** out_, .git_patch* patch, size_t hunk_idx, size_t line_of_hunk);

/**
 * Look up size of patch diff data in bytes
 *
 * This returns the raw size of the patch data.  This only includes the
 * actual data from the lines of the diff, not the file or hunk headers.
 *
 * If you pass `include_context` as true (non-zero), this will be the size
 * of all of the diff output; if you pass it as false (zero), this will
 * only include the actual changed lines (as if `context_lines` was 0).
 *
 * Params:
 *      patch = A git_patch representing changes to one file
 *      include_context = Include context lines in size if non-zero
 *      include_hunk_headers = Include hunk header lines if non-zero
 *      include_file_headers = Include file header lines if non-zero
 *
 * Returns: The number of bytes of data
 */
@GIT_EXTERN
size_t git_patch_size(.git_patch* patch, int include_context, int include_hunk_headers, int include_file_headers);

/**
 * Serialize the patch to text via callback.
 *
 * Returning a non-zero value from the callback will terminate the iteration
 * and return that value to the caller.
 *
 * Params:
 *      patch = A git_patch representing changes to one file
 *      print_cb = Callback function to output lines of the patch.  Will be called for file headers, hunk headers, and diff lines.
 *      payload = Reference pointer that will be passed to your callbacks.
 *
 * Returns: 0 on success, non-zero callback return value, or error code
 */
@GIT_EXTERN
int git_patch_print(.git_patch* patch, libgit2.diff.git_diff_line_cb print_cb, void* payload);

/**
 * Get the content of a patch as a single diff text.
 *
 * Params:
 *      out_ = The git_buf to be filled in
 *      patch = A git_patch representing changes to one file
 *
 * Returns: 0 on success, <0 on failure.
 */
@GIT_EXTERN
int git_patch_to_buf(libgit2.buffer.git_buf* out_, .git_patch* patch);

/*@}*/
