/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.email;


private static import libgit2.buffer;
private static import libgit2.diff;
private static import libgit2.diff;
private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/email.h
 * @brief Git email formatting and application routines.
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/**
 * Formatting options for diff e-mail generation
 */
enum git_email_create_flags_t
{
	/**
	 * Normal patch, the default
	 */
	GIT_EMAIL_CREATE_DEFAULT = 0,

	/**
	 * Do not include patch numbers in the subject prefix.
	 */
	GIT_EMAIL_CREATE_OMIT_NUMBERS = 1u << 0,

	/**
	 * Include numbers in the subject prefix even when the
	 * patch is for a single commit (1/1).
	 */
	GIT_EMAIL_CREATE_ALWAYS_NUMBER = 1u << 1,

	/** Do not perform rename or similarity detection. */
	GIT_EMAIL_CREATE_NO_RENAMES = 1u << 2,
}

/**
 * Options for controlling the formatting of the generated e-mail.
 */
struct git_email_create_options
{
	uint version_;

	/**
	 * see `git_email_create_flags_t` above
	 */
	uint flags;

	/**
	 * Options to use when creating diffs
	 */
	libgit2.diff.git_diff_options diff_opts;

	/**
	 * Options for finding similarities within diffs
	 */
	libgit2.diff.git_diff_find_options diff_find_opts;

	/**
	 * The subject prefix, by default "PATCH".  If set to an empty
	 * string ("") then only the patch numbers will be shown in the
	 * prefix.  If the subject_prefix is empty and patch numbers
	 * are not being shown, the prefix will be omitted entirely.
	 */
	const (char)* subject_prefix;

	/**
	 * The starting patch number; this cannot be 0.  By default,
	 * this is 1.
	 */
	size_t start_number;

	/** The "re-roll" number.  By default, there is no re-roll. */
	size_t reroll_number;
}

/*
 * By default, our options include rename detection and binary
 * diffs to match `git format-patch`.
 */
enum GIT_EMAIL_CREATE_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc @live
.git_email_create_options GIT_EMAIL_CREATE_OPTIONS_INIT()

	do
	{
		.git_email_create_options OUTPUT =
		{
			version_: .GIT_EMAIL_CREATE_OPTIONS_VERSION,
			flags: .git_email_create_flags_t.GIT_EMAIL_CREATE_DEFAULT,
			diff_opts:
			{
				version_: libgit2.diff.GIT_DIFF_OPTIONS_VERSION,
				flags: libgit2.diff.git_diff_option_t.GIT_DIFF_SHOW_BINARY,
				ignore_submodules: libgit2.types.git_submodule_ignore_t.GIT_SUBMODULE_IGNORE_UNSPECIFIED,
				pathspec:
				{
					strings: null,
					count: 0,
				},
				notify_cb: null,
				progress_cb: null,
				payload: null,
				context_lines: 3,
			},
			diff_find_opts: libgit2.diff.GIT_DIFF_FIND_OPTIONS_INIT,
		};

		return OUTPUT;
	}

/**
 * Create a diff for a commit in mbox format for sending via email.
 *
 * Params:
 *      out_ = buffer to store the e-mail patch in
 *      diff = the changes to include in the email
 *      patch_idx = the patch index
 *      patch_count = the total number of patches that will be included
 *      commit_id = the commit id for this change
 *      summary = the commit message for this change
 *      body_ = optional text to include above the diffstat
 *      author = the person who authored this commit
 *      opts = email creation options
 */
@GIT_EXTERN
int git_email_create_from_diff(libgit2.buffer.git_buf* out_, libgit2.diff.git_diff* diff, size_t patch_idx, size_t patch_count, const (libgit2.oid.git_oid)* commit_id, const (char)* summary, const (char)* body_, const (libgit2.types.git_signature)* author, const (.git_email_create_options)* opts);

/**
 * Create a diff for a commit in mbox format for sending via email.
 * The commit must not be a merge commit.
 *
 * Params:
 *      out_ = buffer to store the e-mail patch in
 *      commit = commit to create a patch for
 *      opts = email creation options
 */
@GIT_EXTERN
int git_email_create_from_commit(libgit2.buffer.git_buf* out_, libgit2.types.git_commit* commit, const (.git_email_create_options)* opts);

/* @} */
