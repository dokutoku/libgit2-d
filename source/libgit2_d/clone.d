/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.clone;


private static import libgit2_d.checkout;
private static import libgit2_d.remote;
private static import libgit2_d.types;

/*
 * @file git2/clone.h
 * @brief Git cloning routines
 * @defgroup git_clone Git cloning routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Options for bypassing the git-aware transport on clone. Bypassing
 * it means that instead of a fetch, libgit2 will copy the object
 * database directory instead of figuring out what it needs, which is
 * faster. If possible, it will hardlink the files to save space.
 */
enum git_clone_local_t
{
	/**
	 * Auto-detect (default), libgit2 will bypass the git-aware
	 * transport for local paths, but use a normal fetch for
	 * `file://` urls.
	 */
	GIT_CLONE_LOCAL_AUTO,

	/**
	 * Bypass the git-aware transport even for a `file://` url.
	 */
	GIT_CLONE_LOCAL,

	/**
	 * Do no bypass the git-aware transport
	 */
	GIT_CLONE_NO_LOCAL,

	/**
	 * Bypass the git-aware transport, but do not try to use
	 * hardlinks.
	 */
	GIT_CLONE_LOCAL_NO_LINKS,
}

//Declaration name in C language
enum
{
	GIT_CLONE_LOCAL_AUTO = .git_clone_local_t.GIT_CLONE_LOCAL_AUTO,
	GIT_CLONE_LOCAL = .git_clone_local_t.GIT_CLONE_LOCAL,
	GIT_CLONE_NO_LOCAL = .git_clone_local_t.GIT_CLONE_NO_LOCAL,
	GIT_CLONE_LOCAL_NO_LINKS = .git_clone_local_t.GIT_CLONE_LOCAL_NO_LINKS,
}

/**
 * The signature of a function matching git_remote_create, with an additional
 * void* as a callback payload.
 *
 * Callers of git_clone may provide a function matching this signature to
 * override the remote creation and customization process during a clone
 * operation.
 *
 * Returns: 0, git_error_code.GIT_EINVALIDSPEC, git_error_code.GIT_EEXISTS or an error code
 */
/*
 * Params:
 *      out_ = the resulting remote
 *      repo = the repository in which to create the remote
 *      name = the remote's name
 *      url = the remote's url
 *      payload = an opaque payload
 */
alias git_remote_create_cb = int function(libgit2_d.types.git_remote** out_, libgit2_d.types.git_repository* repo, const (char)* name, const (char)* url, void* payload);

/**
 * The signature of a function matchin git_repository_init, with an
 * aditional void * as callback payload.
 *
 * Callers of git_clone my provide a function matching this signature
 * to override the repository creation and customization process
 * during a clone operation.
 *
 * Returns: 0, or a negative value to indicate error
 */
/*
 * Params:
 *      out_ = the resulting repository
 *      path = path in which to create the repository
 *      bare = whether the repository is bare. This is the value from the clone options
 *      payload = payload specified by the options
 */
alias git_repository_create_cb = int function(libgit2_d.types.git_repository** out_, const (char)* path, int bare, void* payload);

/**
 * Clone options structure
 *
 * Initialize with `GIT_CLONE_OPTIONS_INIT`. Alternatively, you can
 * use `git_clone_options_init`.
 */
struct git_clone_options
{
	uint version_;

	/**
	 * These options are passed to the checkout step. To disable
	 * checkout, set the `checkout_strategy` to
	 * `git_checkout_strategy_t.GIT_CHECKOUT_NONE`.
	 */
	libgit2_d.checkout.git_checkout_options checkout_opts;

	/**
	 * Options which control the fetch, including callbacks.
	 *
	 * The callbacks are used for reporting fetch progress, and for acquiring
	 * credentials in the event they are needed.
	 */
	libgit2_d.remote.git_fetch_options fetch_opts;

	/**
	 * Set to zero (false) to create a standard repo, or non-zero
	 * for a bare repo
	 */
	int bare;

	/**
	 * Whether to use a fetch or copy the object database.
	 */
	.git_clone_local_t local;

	/**
	 * The name of the branch to checkout. null means use the
	 * remote's default branch.
	 */
	const (char)* checkout_branch;

	/**
	 * A callback used to create the new repository into which to
	 * clone. If null, the 'bare' field will be used to determine
	 * whether to create a bare repository.
	 */
	.git_repository_create_cb repository_cb;

	/**
	 * An opaque payload to pass to the libgit2_d.types.git_repository creation callback.
	 * This parameter is ignored unless repository_cb is non-null.
	 */
	void* repository_cb_payload;

	/**
	 * A callback used to create the git_remote, prior to its being
	 * used to perform the clone operation. See the documentation for
	 * git_remote_create_cb for details. This parameter may be null,
	 * indicating that git_clone should provide default behavior.
	 */
	.git_remote_create_cb remote_cb;

	/**
	 * An opaque payload to pass to the git_remote creation callback.
	 * This parameter is ignored unless remote_cb is non-null.
	 */
	void* remote_cb_payload;
}

enum GIT_CLONE_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_clone_options GIT_CLONE_OPTIONS_INIT()

	do
	{
		libgit2_d.checkout.git_checkout_options CHECKOUT_OPTION =
		{
			version_: libgit2_d.checkout.GIT_CHECKOUT_OPTIONS_VERSION,
			checkout_strategy: libgit2_d.checkout.git_checkout_strategy_t.GIT_CHECKOUT_SAFE,
		};

		.git_clone_options OUTPUT =
		{
			version_: .GIT_CLONE_OPTIONS_VERSION,
			checkout_opts: CHECKOUT_OPTION,
			fetch_opts: libgit2_d.remote.GIT_FETCH_OPTIONS_INIT(),
		};

		return OUTPUT;
	}

/**
 * Initialize git_clone_options structure
 *
 * Initializes a `git_clone_options` with default values. Equivalent to creating
 * an instance with GIT_CLONE_OPTIONS_INIT.
 *
 * Params:
 *      opts = The `git_clone_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_CLONE_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_clone_options_init(.git_clone_options* opts, uint version_);

/**
 * Clone a remote repository.
 *
 * By default this creates its repository and initial remote to match
 * git's defaults. You can use the options in the callback to
 * customize how these are created.
 *
 * Params:
 *      out_ = pointer that will receive the resulting repository object
 *      url = the remote repository to clone
 *      local_path = local directory to clone to
 *      options = configuration options for the clone.  If null, the function works as though GIT_OPTIONS_INIT were passed.
 *
 * Returns: 0 on success, any non-zero return value from a callback function, or a negative value to indicate an error (use `git_error_last` for a detailed error message)
 */
//GIT_EXTERN
int git_clone(libgit2_d.types.git_repository** out_, const (char)* url, const (char)* local_path, const (.git_clone_options)* options);

/* @} */
