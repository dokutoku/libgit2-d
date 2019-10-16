/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.describe;


private static import libgit2_d.buffer;
private static import libgit2_d.common;
private static import libgit2_d.types;

/**
 * @file git2/describe.h
 * @brief Git describing routines
 * @defgroup git_describe Git describing routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/**
 * Reference lookup strategy
 *
 * These behave like the --tags and --all options to git-describe,
 * namely they say to look for any reference in either refs/tags/ or
 * refs/ respectively.
 */
enum git_describe_strategy_t
{
	GIT_DESCRIBE_DEFAULT,
	GIT_DESCRIBE_TAGS,
	GIT_DESCRIBE_ALL,
}

/**
 * Describe options structure
 *
 * Initialize with `GIT_DESCRIBE_OPTIONS_INIT` macro to correctly set
 * the `version_` field.  E.g.
 *
 *		git_describe_options opts = GIT_DESCRIBE_OPTIONS_INIT;
 */
struct git_describe_options
{
	uint version_;

	/**< default: 10 */
	uint max_candidates_tags;

	/**< default: GIT_DESCRIBE_DEFAULT */
	uint describe_strategy;

	const (char)* pattern;
	/**
	 * When calculating the distance from the matching tag or
	 * reference, only walk down the first-parent ancestry.
	 */
	int only_follow_first_parent;
	/**
	 * If no matching tag or reference is found, the describe
	 * operation would normally fail. If this option is set, it
	 * will instead fall back to showing the full id of the
	 * commit.
	 */
	int show_commit_oid_as_fallback;
}

enum GIT_DESCRIBE_DEFAULT_MAX_CANDIDATES_TAGS = 10;
enum GIT_DESCRIBE_DEFAULT_ABBREVIATED_SIZE = 7;

enum GIT_DESCRIBE_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_describe_options GIT_DESCRIBE_OPTIONS_INIT()

	do
	{
		.git_describe_options OUTPUT =
		{
			version_: .GIT_DESCRIBE_OPTIONS_VERSION,
			max_candidates_tags: .GIT_DESCRIBE_DEFAULT_MAX_CANDIDATES_TAGS,
		};

		return OUTPUT;
	}

//GIT_EXTERN
int git_describe_init_options(.git_describe_options* opts, uint version_);

/**
 * Options for formatting the describe string
 */
struct git_describe_format_options
{
	uint version_;

	/**
	 * Size of the abbreviated commit id to use. This value is the
	 * lower bound for the length of the abbreviated string. The
	 * default is 7.
	 */
	uint abbreviated_size;

	/**
	 * Set to use the long format even when a shorter name could be used.
	 */
	int always_use_long_format;

	/**
	 * If the workdir is dirty and this is set, this string will
	 * be appended to the description string.
	 */
	const (char)* dirty_suffix;
}

enum GIT_DESCRIBE_FORMAT_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_describe_format_options GIT_DESCRIBE_FORMAT_OPTIONS_INIT()

	do
	{
		.git_describe_format_options OUTPUT =
		{
			version_: .GIT_DESCRIBE_FORMAT_OPTIONS_VERSION,
			abbreviated_size: .GIT_DESCRIBE_DEFAULT_ABBREVIATED_SIZE,
		};

		return OUTPUT;
	}

//GIT_EXTERN
int git_describe_init_format_options(.git_describe_format_options* opts, uint version_);

/**
 * A struct that stores the result of a describe operation.
 */
struct git_describe_result;

/**
 * Describe a commit
 *
 * Perform the describe operation on the given committish object.
 *
 * @param result pointer to store the result. You must free this once
 * you're done with it.
 * @param committish a committish to describe
 * @param opts the lookup options
 */
//GIT_EXTERN
int git_describe_commit(.git_describe_result** result, libgit2_d.types.git_object* committish, .git_describe_options* opts);

/**
 * Describe a commit
 *
 * Perform the describe operation on the current commit and the
 * worktree. After peforming describe on HEAD, a status is run and the
 * description is considered to be dirty if there are.
 *
 * @param out_ pointer to store the result. You must free this once
 * you're done with it.
 * @param repo the repository in which to perform the describe
 * @param opts the lookup options
 */
//GIT_EXTERN
int git_describe_workdir(.git_describe_result** out_, libgit2_d.types.git_repository* repo, .git_describe_options* opts);

/**
 * Print the describe result to a buffer
 *
 * @param out_ The buffer to store the result
 * @param result the result from `git_describe_commit()` or
 * `git_describe_workdir()`.
 * @param opts the formatting options
 */
//GIT_EXTERN
int git_describe_format(libgit2_d.buffer.git_buf* out_, const (.git_describe_result)* result, const (.git_describe_format_options)* opts);

/**
 * Free the describe result.
 */
//GIT_EXTERN
void git_describe_result_free(.git_describe_result* result);

/** @} */
