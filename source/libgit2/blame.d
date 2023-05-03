/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.blame;


private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/blame.h
 * @brief Git blame routines
 * @defgroup git_blame Git blame routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Flags for indicating option behavior for git_blame APIs.
 */
enum git_blame_flag_t
{
	/**
	 * Normal blame, the default
	 */
	GIT_BLAME_NORMAL = 0,

	/**
	 * Track lines that have moved within a file (like `git blame -M`).
	 * NOT IMPLEMENTED.
	 */
	GIT_BLAME_TRACK_COPIES_SAME_FILE = 1 << 0,

	/**
	 * Track lines that have moved across files in the same commit (like `git
	 * blame -C`). NOT IMPLEMENTED.
	 */
	GIT_BLAME_TRACK_COPIES_SAME_COMMIT_MOVES = 1 << 1,

	/**
	 * Track lines that have been copied from another file that exists in the
	 * same commit (like `git blame -CC`). Implies SAME_FILE.
	 * NOT IMPLEMENTED.
	 */
	GIT_BLAME_TRACK_COPIES_SAME_COMMIT_COPIES = 1 << 2,

	/**
	 * Track lines that have been copied from another file that exists in *any*
	 * commit (like `git blame -CCC`). Implies SAME_COMMIT_COPIES.
	 * NOT IMPLEMENTED.
	 */
	GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES = 1 << 3,

	/**
	 * Restrict the search of commits to those reachable following only the
	 * first parents.
	 */
	GIT_BLAME_FIRST_PARENT = 1 << 4,

	/**
	 * Use mailmap file to map author and committer names and email addresses
	 * to canonical real names and email addresses. The mailmap will be read
	 * from the working directory, or HEAD in a bare repository.
	 */
	GIT_BLAME_USE_MAILMAP = 1 << 5,

	/**
	 * Ignore whitespace differences
	 */
	GIT_BLAME_IGNORE_WHITESPACE = 1 << 6,
}

//Declaration name in C language
enum
{
	GIT_BLAME_NORMAL = .git_blame_flag_t.GIT_BLAME_NORMAL,
	GIT_BLAME_TRACK_COPIES_SAME_FILE = .git_blame_flag_t.GIT_BLAME_TRACK_COPIES_SAME_FILE,
	GIT_BLAME_TRACK_COPIES_SAME_COMMIT_MOVES = .git_blame_flag_t.GIT_BLAME_TRACK_COPIES_SAME_COMMIT_MOVES,
	GIT_BLAME_TRACK_COPIES_SAME_COMMIT_COPIES = .git_blame_flag_t.GIT_BLAME_TRACK_COPIES_SAME_COMMIT_COPIES,
	GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES = .git_blame_flag_t.GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES,
	GIT_BLAME_FIRST_PARENT = .git_blame_flag_t.GIT_BLAME_FIRST_PARENT,
	GIT_BLAME_USE_MAILMAP = .git_blame_flag_t.GIT_BLAME_USE_MAILMAP,
	GIT_BLAME_IGNORE_WHITESPACE = .git_blame_flag_t.GIT_BLAME_IGNORE_WHITESPACE,
}

/**
 * Blame options structure
 *
 * Initialize with `GIT_BLAME_OPTIONS_INIT`. Alternatively, you can
 * use `git_blame_options_init`.
 */
struct git_blame_options
{
	uint version_;

	/**
	 * A combination of `git_blame_flag_t`
	 */
	uint flags;

	/**
	 * The lower bound on the number of alphanumeric
	 *   characters that must be detected as moving/copying within a file for it to
	 *   associate those lines with the parent commit. The default value is 20.
	 *   This value only takes effect if any of the `GIT_BLAME_TRACK_COPIES_*`
	 *   flags are specified.
	 */
	ushort min_match_characters;

	/**
	 * The id of the newest commit to consider. The default is HEAD.
	 */
	libgit2.oid.git_oid newest_commit;

	/**
	 * The id of the oldest commit to consider.
	 * The default is the first commit encountered with a null parent.
	 */
	libgit2.oid.git_oid oldest_commit;

	/**
	 * The first line in the file to blame.
	 * The default is 1 (line numbers start with 1).
	 */
	size_t min_line;

	/**
	 * The last line in the file to blame.
	 * The default is the last line of the file.
	 */
	size_t max_line;
}

enum GIT_BLAME_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_blame_options GIT_BLAME_OPTIONS_INIT()

	do
	{
		.git_blame_options OUTPUT =
		{
			version_: .GIT_BLAME_OPTIONS_VERSION,
		};

		return OUTPUT;
	}

/**
 * Initialize git_blame_options structure
 *
 * Initializes a `git_blame_options` with default values. Equivalent to creating
 * an instance with GIT_BLAME_OPTIONS_INIT.
 *
 * Params:
 *      opts = The `git_blame_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_BLAME_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
@GIT_EXTERN
int git_blame_options_init(.git_blame_options* opts, uint version_);

/**
 * Structure that represents a blame hunk.
 *
 * - `lines_in_hunk` is the number of lines in this hunk
 * - `final_commit_id` is the OID of the commit where this line was last
 *   changed.
 * - `final_start_line_number` is the 1-based line number where this hunk
 *   begins, in the final version of the file
 * - `final_signature` is the author of `final_commit_id`. If
 *   `git_blame_flag_t.GIT_BLAME_USE_MAILMAP` has been specified, it will contain the canonical
 *    real name and email address.
 * - `orig_commit_id` is the OID of the commit where this hunk was found.  This
 *   will usually be the same as `final_commit_id`, except when
 *   `git_blame_flag_t.GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES` has been specified.
 * - `orig_path` is the path to the file where this hunk originated, as of the
 *   commit specified by `orig_commit_id`.
 * - `orig_start_line_number` is the 1-based line number where this hunk begins
 *   in the file named by `orig_path` in the commit specified by
 *   `orig_commit_id`.
 * - `orig_signature` is the author of `orig_commit_id`. If
 *   `git_blame_flag_t.GIT_BLAME_USE_MAILMAP` has been specified, it will contain the canonical
 *    real name and email address.
 * - `boundary` is 1 iff the hunk has been tracked to a boundary commit (the
 *   root, or the commit specified in git_blame_options.oldest_commit)
 */
struct git_blame_hunk
{
	size_t lines_in_hunk;

	libgit2.oid.git_oid final_commit_id;
	size_t final_start_line_number;
	libgit2.types.git_signature* final_signature;

	libgit2.oid.git_oid orig_commit_id;
	const (char)* orig_path;
	size_t orig_start_line_number;
	libgit2.types.git_signature* orig_signature;

	char boundary = '\0';
}

/**
 * Opaque structure to hold blame results
 */
struct git_blame;

/**
 * Gets the number of hunks that exist in the blame structure.
 */
@GIT_EXTERN
uint git_blame_get_hunk_count(.git_blame* blame);

/**
 * Gets the blame hunk at the given index.
 *
 * Params:
 *      blame = the blame structure to query
 *      index = index of the hunk to retrieve
 *
 * Returns: the hunk at the given index, or null on error
 */
@GIT_EXTERN
const (.git_blame_hunk)* git_blame_get_hunk_byindex(.git_blame* blame, uint index);

/**
 * Gets the hunk that relates to the given line number in the newest commit.
 *
 * Params:
 *      blame = the blame structure to query
 *      lineno = the (1-based) line number to find a hunk for
 *
 * Returns: the hunk that contains the given line, or null on error
 */
@GIT_EXTERN
const (.git_blame_hunk)* git_blame_get_hunk_byline(.git_blame* blame, size_t lineno);

/**
 * Get the blame for a single file.
 *
 * Params:
 *      out_ = pointer that will receive the blame object
 *      repo = repository whose history is to be walked
 *      path = path to file to consider
 *      options = options for the blame operation.  If null, this is treated as though GIT_BLAME_OPTIONS_INIT were passed.
 *
 * Returns: 0 on success, or an error code. (use git_error_last for information about the error.)
 */
@GIT_EXTERN
int git_blame_file(.git_blame** out_, libgit2.types.git_repository* repo, const (char)* path, .git_blame_options* options);

/**
 * Get blame data for a file that has been modified in memory. The `reference`
 * parameter is a pre-calculated blame for the in-odb history of the file. This
 * means that once a file blame is completed (which can be expensive), updating
 * the buffer blame is very fast.
 *
 * Lines that differ between the buffer and the committed version are marked as
 * having a zero OID for their final_commit_id.
 *
 * Params:
 *      out_ = pointer that will receive the resulting blame data
 *      reference = cached blame from the history of the file (usually the output from git_blame_file)
 *      buffer = the (possibly) modified contents of the file
 *      buffer_len = number of valid bytes in the buffer
 *
 * Returns: 0 on success, or an error code. (use git_error_last for information about the error)
 */
@GIT_EXTERN
int git_blame_buffer(.git_blame** out_, .git_blame* reference, const (char)* buffer, size_t buffer_len);

/**
 * Free memory allocated by git_blame_file or git_blame_buffer.
 *
 * Params:
 *      blame = the blame structure to free
 */
@GIT_EXTERN
void git_blame_free(.git_blame* blame);

/* @} */
