/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.remote;


private static import libgit2_d.buffer;
private static import libgit2_d.cert;
private static import libgit2_d.credential;
private static import libgit2_d.indexer;
private static import libgit2_d.net;
private static import libgit2_d.oid;
private static import libgit2_d.pack;
private static import libgit2_d.proxy;
private static import libgit2_d.strarray;
private static import libgit2_d.transport;
private static import libgit2_d.types;

/*
 * @file git2/remote.h
 * @brief Git remote management functions
 * @defgroup git_remote remote management functions
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Add a remote with the default fetch refspec to the repository's
 * configuration.
 *
 * Params:
 *      out_ = the resulting remote
 *      repo = the repository in which to create the remote
 *      name = the remote's name
 *      url = the remote's url
 *
 * Returns: 0, git_error_code.GIT_EINVALIDSPEC, git_error_code.GIT_EEXISTS or an error code
 */
//GIT_EXTERN
int git_remote_create(libgit2_d.types.git_remote** out_, libgit2_d.types.git_repository* repo, const (char)* name, const (char)* url);

/**
 * Remote creation options flags
 */
enum git_remote_create_flags
{
	/**
	 * Ignore the repository apply.insteadOf configuration
	 */
	GIT_REMOTE_CREATE_SKIP_INSTEADOF = 1 << 0,

	/**
	 * Don't build a fetchspec from the name if none is set
	 */
	GIT_REMOTE_CREATE_SKIP_DEFAULT_FETCHSPEC = 1 << 1,
}

//Declaration name in C language
enum
{
	GIT_REMOTE_CREATE_SKIP_INSTEADOF = .git_remote_create_flags.GIT_REMOTE_CREATE_SKIP_INSTEADOF,
	GIT_REMOTE_CREATE_SKIP_DEFAULT_FETCHSPEC = .git_remote_create_flags.GIT_REMOTE_CREATE_SKIP_DEFAULT_FETCHSPEC,
}

/**
 * Remote creation options structure
 *
 * Initialize with `GIT_REMOTE_CREATE_OPTIONS_INIT`. Alternatively, you can
 * use `git_remote_create_options_init`.
 *
 */
struct git_remote_create_options
{
	uint version_;

	/**
	 * The repository that should own the remote.
	 * Setting this to NULL results in a detached remote.
	 */
	libgit2_d.types.git_repository* repository;

	/**
	 * The remote's name.
	 * Setting this to NULL results in an in-memory/anonymous remote.
	 */
	const (char)* name;

	/**
	 * The fetchspec the remote should use.
	 */
	const (char)* fetchspec;

	/**
	 * Additional flags for the remote. See git_remote_create_flags.
	 */
	uint flags;
}

enum GIT_REMOTE_CREATE_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_remote_create_options GIT_REMOTE_CREATE_OPTIONS_INIT()

	do
	{
		.git_remote_create_options OUTPUT =
		{
			version_: GIT_REMOTE_CREATE_OPTIONS_VERSION,
		};

		return OUTPUT;
	}

/**
 * Initialize git_remote_create_options structure
 *
 * Initializes a `git_remote_create_options` with default values. Equivalent to
 * creating an instance with `GIT_REMOTE_CREATE_OPTIONS_INIT`.
 *
 * Params:
 *      opts = The `git_remote_create_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_REMOTE_CREATE_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_remote_create_options_init(.git_remote_create_options* opts, uint version_);

/**
 * Create a remote, with options.
 *
 * This function allows more fine-grained control over the remote creation.
 *
 * Passing NULL as the opts argument will result in a detached remote.
 *
 * Params:
 *      out_ = the resulting remote
 *      url = the remote's url
 *      opts = the remote creation options
 *
 * Returns: 0, git_error_code.GIT_EINVALIDSPEC, git_error_code.GIT_EEXISTS or an error code
 */
//GIT_EXTERN
int git_remote_create_with_opts(libgit2_d.types.git_remote** out_, const (char)* url, const (.git_remote_create_options)* opts);

/**
 * Add a remote with the provided fetch refspec (or default if null) to the
 * repository's configuration.
 *
 * Params:
 *      out_ = the resulting remote
 *      repo = the repository in which to create the remote
 *      name = the remote's name
 *      url = the remote's url
 *      fetch = the remote fetch value
 *
 * Returns: 0, git_error_code.GIT_EINVALIDSPEC, git_error_code.GIT_EEXISTS or an error code
 */
//GIT_EXTERN
int git_remote_create_with_fetchspec(libgit2_d.types.git_remote** out_, libgit2_d.types.git_repository* repo, const (char)* name, const (char)* url, const (char)* fetch);

/**
 * Create an anonymous remote
 *
 * Create a remote with the given url in-memory. You can use this when
 * you have a URL instead of a remote's name.
 *
 * Params:
 *      out_ = pointer to the new remote objects
 *      repo = the associated repository
 *      url = the remote repository's URL
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_remote_create_anonymous(libgit2_d.types.git_remote** out_, libgit2_d.types.git_repository* repo, const (char)* url);

/**
 * Create a remote without a connected local repo
 *
 * Create a remote with the given url in-memory. You can use this when
 * you have a URL instead of a remote's name.
 *
 * Contrasted with git_remote_create_anonymous, a detached remote
 * will not consider any repo configuration values (such as insteadof url
 * substitutions).
 *
 * Params:
 *      out_ = pointer to the new remote objects
 *      url = the remote repository's URL
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_remote_create_detached(libgit2_d.types.git_remote** out_, const (char)* url);

/**
 * Get the information for a particular remote
 *
 * The name will be checked for validity.
 * See `git_tag_create()` for rules about valid names.
 *
 * Params:
 *      out_ = pointer to the new remote object
 *      repo = the associated repository
 *      name = the remote's name
 *
 * Returns: 0, git_error_code.GIT_ENOTFOUND, git_error_code.GIT_EINVALIDSPEC or an error code
 */
//GIT_EXTERN
int git_remote_lookup(libgit2_d.types.git_remote** out_, libgit2_d.types.git_repository* repo, const (char)* name);

/**
 * Create a copy of an existing remote.  All internal strings are also
 * duplicated. Callbacks are not duplicated.
 *
 * Call `git_remote_free` to free the data.
 *
 * Params:
 *      dest = pointer where to store the copy
 *      source = object to copy
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_remote_dup(libgit2_d.types.git_remote** dest, libgit2_d.types.git_remote* source);

/**
 * Get the remote's repository
 *
 * Params:
 *      remote = the remote
 *
 * Returns: a pointer to the repository
 */
//GIT_EXTERN
libgit2_d.types.git_repository* git_remote_owner(const (libgit2_d.types.git_remote)* remote);

/**
 * Get the remote's name
 *
 * Params:
 *      remote = the remote
 *
 * Returns: a pointer to the name or null for in-memory remotes
 */
//GIT_EXTERN
const (char)* git_remote_name(const (libgit2_d.types.git_remote)* remote);

/**
 * Get the remote's url
 *
 * If url.*.insteadOf has been configured for this URL, it will
 * return the modified URL.
 *
 * Params:
 *      remote = the remote
 *
 * Returns: a pointer to the url
 */
//GIT_EXTERN
const (char)* git_remote_url(const (libgit2_d.types.git_remote)* remote);

/**
 * Get the remote's url for pushing
 *
 * If url.*.pushInsteadOf has been configured for this URL, it
 * will return the modified URL.
 *
 * Params:
 *      remote = the remote
 *
 * Returns: a pointer to the url or null if no special url for pushing is set
 */
//GIT_EXTERN
const (char)* git_remote_pushurl(const (libgit2_d.types.git_remote)* remote);

/**
 * Set the remote's url in the configuration
 *
 * Remote objects already in memory will not be affected. This assumes
 * the common case of a single-url remote and will otherwise return an error.
 *
 * Params:
 *      repo = the repository in which to perform the change
 *      remote = the remote's name
 *      url = the url to set
 *
 * Returns: 0 or an error value
 */
//GIT_EXTERN
int git_remote_set_url(libgit2_d.types.git_repository* repo, const (char)* remote, const (char)* url);

/**
 * Set the remote's url for pushing in the configuration.
 *
 * Remote objects already in memory will not be affected. This assumes
 * the common case of a single-url remote and will otherwise return an error.
 *
 *
 * Params:
 *      repo = the repository in which to perform the change
 *      remote = the remote's name
 *      url = the url to set
 */
//GIT_EXTERN
int git_remote_set_pushurl(libgit2_d.types.git_repository* repo, const (char)* remote, const (char)* url);

/**
 * Add a fetch refspec to the remote's configuration
 *
 * Add the given refspec to the fetch list in the configuration. No
 * loaded remote instances will be affected.
 *
 * Params:
 *      repo = the repository in which to change the configuration
 *      remote = the name of the remote to change
 *      refspec = the new fetch refspec
 *
 * Returns: 0, git_error_code.GIT_EINVALIDSPEC if refspec is invalid or an error value
 */
//GIT_EXTERN
int git_remote_add_fetch(libgit2_d.types.git_repository* repo, const (char)* remote, const (char)* refspec);

/**
 * Get the remote's list of fetch refspecs
 *
 * The memory is owned by the user and should be freed with
 * `git_strarray_free`.
 *
 * Params:
 *      array = pointer to the array in which to store the strings
 *      remote = the remote to query
 */
//GIT_EXTERN
int git_remote_get_fetch_refspecs(libgit2_d.strarray.git_strarray* array, const (libgit2_d.types.git_remote)* remote);

/**
 * Add a push refspec to the remote's configuration
 *
 * Add the given refspec to the push list in the configuration. No
 * loaded remote instances will be affected.
 *
 * Params:
 *      repo = the repository in which to change the configuration
 *      remote = the name of the remote to change
 *      refspec = the new push refspec
 *
 * Returns: 0, git_error_code.GIT_EINVALIDSPEC if refspec is invalid or an error value
 */
//GIT_EXTERN
int git_remote_add_push(libgit2_d.types.git_repository* repo, const (char)* remote, const (char)* refspec);

/**
 * Get the remote's list of push refspecs
 *
 * The memory is owned by the user and should be freed with
 * `git_strarray_free`.
 *
 * Params:
 *      array = pointer to the array in which to store the strings
 *      remote = the remote to query
 */
//GIT_EXTERN
int git_remote_get_push_refspecs(libgit2_d.strarray.git_strarray* array, const (libgit2_d.types.git_remote)* remote);

/**
 * Get the number of refspecs for a remote
 *
 * Params:
 *      remote = the remote
 *
 * Returns: the amount of refspecs configured in this remote
 */
//GIT_EXTERN
size_t git_remote_refspec_count(const (libgit2_d.types.git_remote)* remote);

/**
 * Get a refspec from the remote
 *
 * Params:
 *      remote = the remote to query
 *      n = the refspec to get
 *
 * Returns: the nth refspec
 */
//GIT_EXTERN
const (libgit2_d.types.git_refspec)* git_remote_get_refspec(const (libgit2_d.types.git_remote)* remote, size_t n);

/**
 * Open a connection to a remote
 *
 * The transport is selected based on the URL. The direction argument
 * is due to a limitation of the git protocol (over TCP or SSH) which
 * starts up a specific binary which can only do the one or the other.
 *
 * Params:
 *      remote = the remote to connect to
 *      direction = git_direction.GIT_DIRECTION_FETCH if you want to fetch or git_direction.GIT_DIRECTION_PUSH if you want to push
 *      callbacks = the callbacks to use for this connection
 *      proxy_opts = proxy settings
 *      custom_headers = extra HTTP headers to use in this connection
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_remote_connect(libgit2_d.types.git_remote* remote, libgit2_d.net.git_direction direction, const (.git_remote_callbacks)* callbacks, const (libgit2_d.proxy.git_proxy_options)* proxy_opts, const (libgit2_d.strarray.git_strarray)* custom_headers);

/**
 * Get the remote repository's reference advertisement list
 *
 * Get the list of references with which the server responds to a new
 * connection.
 *
 * The remote (or more exactly its transport) must have connected to
 * the remote repository. This list is available as soon as the
 * connection to the remote is initiated and it remains available
 * after disconnecting.
 *
 * The memory belongs to the remote. The pointer will be valid as long
 * as a new connection is not initiated, but it is recommended that
 * you make a copy in order to make use of the data.
 *
 * Params:
 *      out_ = pointer to the array
 *      size = the number of remote heads
 *      remote = the remote
 *
 * Returns: 0 on success, or an error code
 */
//GIT_EXTERN
int git_remote_ls(const (libgit2_d.types.git_remote_head)*** out_, size_t* size, libgit2_d.types.git_remote* remote);

/**
 * Check whether the remote is connected
 *
 * Check whether the remote's underlying transport is connected to the
 * remote host.
 *
 * Params:
 *      remote = the remote
 *
 * Returns: 1 if it's connected, 0 otherwise.
 */
//GIT_EXTERN
int git_remote_connected(const (libgit2_d.types.git_remote)* remote);

/**
 * Cancel the operation
 *
 * At certain points in its operation, the network code checks whether
 * the operation has been cancelled and if so stops the operation.
 *
 * Params:
 *      remote = the remote
 *
 * Returns: 0 on success, or an error code
 */
//GIT_EXTERN
int git_remote_stop(libgit2_d.types.git_remote* remote);

/**
 * Disconnect from the remote
 *
 * Close the connection to the remote.
 *
 * Params:
 *      remote = the remote to disconnect from
 *
 * Returns: 0 on success, or an error code
 */
//GIT_EXTERN
int git_remote_disconnect(libgit2_d.types.git_remote* remote);

/**
 * Free the memory associated with a remote
 *
 * This also disconnects from the remote, if the connection
 * has not been closed yet (using git_remote_disconnect).
 *
 * Params:
 *      remote = the remote to free
 */
//GIT_EXTERN
void git_remote_free(libgit2_d.types.git_remote* remote);

/**
 * Get a list of the configured remotes for a repo
 *
 * The string array must be freed by the user.
 *
 * Params:
 *      out_ = a string array which receives the names of the remotes
 *      repo = the repository to query
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_remote_list(libgit2_d.strarray.git_strarray* out_, libgit2_d.types.git_repository* repo);

/**
 * Argument to the completion callback which tells it which operation
 * finished.
 */
enum git_remote_completion_t
{
	GIT_REMOTE_COMPLETION_DOWNLOAD,
	GIT_REMOTE_COMPLETION_INDEXING,
	GIT_REMOTE_COMPLETION_ERROR,
}

//Declaration name in C language
enum
{
	GIT_REMOTE_COMPLETION_DOWNLOAD = .git_remote_completion_t.GIT_REMOTE_COMPLETION_DOWNLOAD,
	GIT_REMOTE_COMPLETION_INDEXING = .git_remote_completion_t.GIT_REMOTE_COMPLETION_INDEXING,
	GIT_REMOTE_COMPLETION_ERROR = .git_remote_completion_t.GIT_REMOTE_COMPLETION_ERROR,
}

/**
 * Push network progress notification function
 */
alias git_push_transfer_progress_cb = int function(uint current, uint total, size_t bytes, void* payload);

/**
 * Represents an update which will be performed on the remote during push
 */
struct git_push_update
{
	/**
	 * The source name of the reference
	 */
	char* src_refname;

	/**
	 * The name of the reference to update on the server
	 */
	char* dst_refname;

	/**
	 * The current target of the reference
	 */
	libgit2_d.oid.git_oid src;

	/**
	 * The new target for the reference
	 */
	libgit2_d.oid.git_oid dst;
}

/**
 * Callback used to inform of upcoming updates.
 */
/*
 * Params:
 *      updates = an array containing the updates which will be sent as commands to the destination.
 *      len = number of elements in `updates`
 *      payload = Payload provided by the caller
 */
alias git_push_negotiation = int function(const (.git_push_update)** updates, size_t len, void* payload);

/**
 * Callback used to inform of the update status from the remote.
 *
 * Called for each updated reference on push. If `status` is
 * not `null`, the update was rejected by the remote server
 * and `status` contains the reason given.
 *
 * Returns: 0 on success, otherwise an error
 */
/*
 * Params:
 *      refname = refname specifying to the remote ref
 *      status = status message sent from the remote
 *      data = data provided by the caller
 */
alias git_push_update_reference_cb = int function(const (char)* refname, const (char)* status, void* data);

/**
 * Callback to resolve URLs before connecting to remote
 *
 * If you return git_error_code.GIT_PASSTHROUGH, you don't need to write anything to
 * url_resolved.
 *
 * Returns: 0 on success, git_error_code.GIT_PASSTHROUGH or an error
 */
/*
 * Params:
 *      url_resolved = The buffer to write the resolved URL to
 *      url = The URL to resolve
 *      direction = git_direction.GIT_DIRECTION_FETCH or git_direction.GIT_DIRECTION_PUSH
 *      payload = Payload provided by the caller
 */
alias git_url_resolve_cb = int function(libgit2_d.buffer.git_buf* url_resolved, const (char)* url, int direction, void* payload);

/**
 * The callback settings structure
 *
 * Set the callbacks to be called by the remote when informing the user
 * about the progress of the network operations.
 */
struct git_remote_callbacks
{
	/**
	 * The version
	 */
	uint version_;

	/**
	 * Textual progress from the remote. Text send over the
	 * progress side-band will be passed to this function (this is
	 * the 'counting objects' output).
	 */
	libgit2_d.transport.git_transport_message_cb sideband_progress;

	/**
	 * Completion is called when different parts of the download
	 * process are done (currently unused).
	 */
	int function(.git_remote_completion_t type, void* data) completion;

	/**
	 * This will be called if the remote host requires
	 * authentication in order to connect to it.
	 *
	 * Returning git_error_code.GIT_PASSTHROUGH will make libgit2 behave as
	 * though this field isn't set.
	 */
	libgit2_d.credential.git_credential_acquire_cb credentials;

	/**
	 * If cert verification fails, this will be called to let the
	 * user make the final decision of whether to allow the
	 * connection to proceed. Returns 0 to allow the connection
	 * or a negative value to indicate an error.
	 */
	libgit2_d.cert.git_transport_certificate_check_cb certificate_check;

	/**
	 * During the download of new data, this will be regularly
	 * called with the current count of progress done by the
	 * indexer.
	 */
	libgit2_d.indexer.git_indexer_progress_cb transfer_progress;

	/**
	 * Each time a reference is updated locally, this function
	 * will be called with information about it.
	 */
	int function(const (char)* refname, const (libgit2_d.oid.git_oid)* a, const (libgit2_d.oid.git_oid)* b, void* data) update_tips;

	/**
	 * Function to call with progress information during pack
	 * building. Be aware that this is called inline with pack
	 * building operations, so performance may be affected.
	 */
	libgit2_d.pack.git_packbuilder_progress pack_progress;

	/**
	 * Function to call with progress information during the
	 * upload portion of a push. Be aware that this is called
	 * inline with pack building operations, so performance may be
	 * affected.
	 */
	.git_push_transfer_progress_cb push_transfer_progress;

	/**
	 * See documentation of git_push_update_reference_cb
	 */
	.git_push_update_reference_cb push_update_reference;

	/**
	 * Called once between the negotiation step and the upload. It
	 * provides information about what updates will be performed.
	 */
	.git_push_negotiation push_negotiation;

	/**
	 * Create the transport to use for this operation. Leave null
	 * to auto-detect.
	 */
	libgit2_d.transport.git_transport_cb transport;

	/**
	 * This will be passed to each of the callbacks in this struct
	 * as the last parameter.
	 */
	void* payload;

	/**
	 * Resolve URL before connecting to remote.
	 * The returned URL will be used to connect to the remote instead.
	 */
	.git_url_resolve_cb resolve_url;
}

enum GIT_REMOTE_CALLBACKS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_remote_callbacks GIT_REMOTE_CALLBACKS_INIT()

	do
	{
		.git_remote_callbacks OUTPUT =
		{
			version_: .GIT_REMOTE_CALLBACKS_VERSION,
		};

		return OUTPUT;
	}

/**
 * Initializes a `git_remote_callbacks` with default values. Equivalent to
 * creating an instance with GIT_REMOTE_CALLBACKS_INIT.
 *
 * Params:
 *      opts = the `git_remote_callbacks` struct to initialize
 *      version_ = Version of struct; pass `GIT_REMOTE_CALLBACKS_VERSION`
 *
 * Returns: Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_remote_init_callbacks(.git_remote_callbacks* opts, uint version_);

/**
 * Acceptable prune settings when fetching
 */
enum git_fetch_prune_t
{
	/**
	 * Use the setting from the configuration
	 */
	GIT_FETCH_PRUNE_UNSPECIFIED,

	/**
	 * Force pruning on
	 */
	GIT_FETCH_PRUNE,

	/**
	 * Force pruning off
	 */
	GIT_FETCH_NO_PRUNE,
}

//Declaration name in C language
enum
{
	GIT_FETCH_PRUNE_UNSPECIFIED = .git_fetch_prune_t.GIT_FETCH_PRUNE_UNSPECIFIED,
	GIT_FETCH_PRUNE = .git_fetch_prune_t.GIT_FETCH_PRUNE,
	GIT_FETCH_NO_PRUNE = .git_fetch_prune_t.GIT_FETCH_NO_PRUNE,
}

/**
 * Automatic tag following option
 *
 * Lets us select the --tags option to use.
 */
enum git_remote_autotag_option_t
{
	/**
	 * Use the setting from the configuration.
	 */
	GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED = 0,

	/**
	 * Ask the server for tags pointing to objects we're already
	 * downloading.
	 */
	GIT_REMOTE_DOWNLOAD_TAGS_AUTO,

	/**
	 * Don't ask for any tags beyond the refspecs.
	 */
	GIT_REMOTE_DOWNLOAD_TAGS_NONE,

	/**
	 * Ask for the all the tags.
	 */
	GIT_REMOTE_DOWNLOAD_TAGS_ALL,
}

//Declaration name in C language
enum
{
	GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED = .git_remote_autotag_option_t.GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED,
	GIT_REMOTE_DOWNLOAD_TAGS_AUTO = .git_remote_autotag_option_t.GIT_REMOTE_DOWNLOAD_TAGS_AUTO,
	GIT_REMOTE_DOWNLOAD_TAGS_NONE = .git_remote_autotag_option_t.GIT_REMOTE_DOWNLOAD_TAGS_NONE,
	GIT_REMOTE_DOWNLOAD_TAGS_ALL = .git_remote_autotag_option_t.GIT_REMOTE_DOWNLOAD_TAGS_ALL,
}

/**
 * Fetch options structure.
 *
 * Zero out for defaults.  Initialize with `GIT_FETCH_OPTIONS_INIT` macro to
 * correctly set the `version_` field.  E.g.
 *
 *		git_fetch_options opts = GIT_FETCH_OPTIONS_INIT;
 */
struct git_fetch_options
{
	int version_;

	/**
	 * Callbacks to use for this fetch operation
	 */
	.git_remote_callbacks callbacks;

	/**
	 * Whether to perform a prune after the fetch
	 */
	.git_fetch_prune_t prune;

	/**
	 * Whether to write the results to FETCH_HEAD. Defaults to
	 * on. Leave this default in order to behave like git.
	 */
	int update_fetchhead;

	/**
	 * Determines how to behave regarding tags on the remote, such
	 * as auto-downloading tags for objects we're downloading or
	 * downloading all of them.
	 *
	 * The default is to auto-follow tags.
	 */
	.git_remote_autotag_option_t download_tags;

	/**
	 * Proxy options to use, by default no proxy is used.
	 */
	libgit2_d.proxy.git_proxy_options proxy_opts;

	/**
	 * Extra headers for this fetch operation
	 */
	libgit2_d.strarray.git_strarray custom_headers;
}

enum GIT_FETCH_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_fetch_options GIT_FETCH_OPTIONS_INIT()

	do
	{
		.git_fetch_options OUTPUT =
		{
			version_: .GIT_FETCH_OPTIONS_VERSION,
			callbacks: .GIT_REMOTE_CALLBACKS_INIT(),
			prune: .git_fetch_prune_t.GIT_FETCH_PRUNE_UNSPECIFIED,
			update_fetchhead: 1,
			download_tags: .git_remote_autotag_option_t.GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED,
			proxy_opts: libgit2_d.proxy.GIT_PROXY_OPTIONS_INIT(),
		};

		return OUTPUT;
	}

/**
 * Initialize git_fetch_options structure
 *
 * Initializes a `git_fetch_options` with default values. Equivalent to
 * creating an instance with `GIT_FETCH_OPTIONS_INIT`.
 *
 * Params:
 *      opts = The `git_fetch_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_FETCH_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_fetch_options_init(.git_fetch_options* opts, uint version_);

/**
 * Controls the behavior of a git_push object.
 */
struct git_push_options
{
	uint version_;

	/**
	 * If the transport being used to push to the remote requires the creation
	 * of a pack file, this controls the number of worker threads used by
	 * the packbuilder when creating that pack file to be sent to the remote.
	 *
	 * If set to 0, the packbuilder will auto-detect the number of threads
	 * to create. The default value is 1.
	 */
	uint pb_parallelism;

	/**
	 * Callbacks to use for this push operation
	 */
	.git_remote_callbacks callbacks;

	/**
	 * Proxy options to use, by default no proxy is used.
	 */
	libgit2_d.proxy.git_proxy_options proxy_opts;

	/**
	 * Extra headers for this push operation
	 */
	libgit2_d.strarray.git_strarray custom_headers;
}

enum GIT_PUSH_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_push_options GIT_PUSH_OPTIONS_INIT()

	do
	{
		.git_push_options OUTPUT =
		{
			version_: .GIT_PUSH_OPTIONS_VERSION,
			pb_parallelism: 1,
			callbacks: .GIT_REMOTE_CALLBACKS_INIT(),
			proxy_opts: libgit2_d.proxy.GIT_PROXY_OPTIONS_INIT(),
		};

		return OUTPUT;
	}

/**
 * Initialize git_push_options structure
 *
 * Initializes a `git_push_options` with default values. Equivalent to
 * creating an instance with `GIT_PUSH_OPTIONS_INIT`.
 *
 * Params:
 *      opts = The `git_push_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_PUSH_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_push_options_init(.git_push_options* opts, uint version_);

/**
 * Download and index the packfile
 *
 * Connect to the remote if it hasn't been done yet, negotiate with
 * the remote git which objects are missing, download and index the
 * packfile.
 *
 * The .idx file will be created and both it and the packfile with be
 * renamed to their final name.
 *
 * Params:
 *      remote = the remote
 *      refspecs = the refspecs to use for this negotiation and download. Use null or an empty array to use the base refspecs
 *      opts = the options to use for this fetch
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_remote_download(libgit2_d.types.git_remote* remote, const (libgit2_d.strarray.git_strarray)* refspecs, const (.git_fetch_options)* opts);

/**
 * Create a packfile and send it to the server
 *
 * Connect to the remote if it hasn't been done yet, negotiate with
 * the remote git which objects are missing, create a packfile with the missing
 * objects and send it.
 *
 * Params:
 *      remote = the remote
 *      refspecs = the refspecs to use for this negotiation and upload. Use null or an empty array to use the base refspecs
 *      opts = the options to use for this push
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_remote_upload(libgit2_d.types.git_remote* remote, const (libgit2_d.strarray.git_strarray)* refspecs, const (.git_push_options)* opts);

/**
 * Update the tips to the new state
 *
 * Params:
 *      remote = the remote to update
 *      reflog_message = The message to insert into the reflogs. If null and fetching, the default is "fetch <name>", where <name> is the name of the remote (or its url, for in-memory remotes). This parameter is ignored when pushing.
 *      callbacks = pointer to the callback structure to use
 *      update_fetchhead = whether to write to FETCH_HEAD. Pass 1 to behave like git.
 *      download_tags = what the behaviour for downloading tags is for this fetch. This is ignored for push. This must be the same value passed to `git_remote_download()`.
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_remote_update_tips(libgit2_d.types.git_remote* remote, const (.git_remote_callbacks)* callbacks, int update_fetchhead, .git_remote_autotag_option_t download_tags, const (char)* reflog_message);

/**
 * Download new data and update tips
 *
 * Convenience function to connect to a remote, download the data,
 * disconnect and update the remote-tracking branches.
 *
 * Params:
 *      remote = the remote to fetch from
 *      refspecs = the refspecs to use for this fetch. Pass null or an empty array to use the base refspecs.
 *      opts = options to use for this fetch
 *      reflog_message = The message to insert into the reflogs. If null, the default is "fetch"
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_remote_fetch(libgit2_d.types.git_remote* remote, const (libgit2_d.strarray.git_strarray)* refspecs, const (.git_fetch_options)* opts, const (char)* reflog_message);

/**
 * Prune tracking refs that are no longer present on remote
 *
 * Params:
 *      remote = the remote to prune
 *      callbacks = callbacks to use for this prune
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_remote_prune(libgit2_d.types.git_remote* remote, const (.git_remote_callbacks)* callbacks);

/**
 * Perform a push
 *
 * Peform all the steps from a push.
 *
 * Params:
 *      remote = the remote to push to
 *      refspecs = the refspecs to use for pushing. If null or an empty array, the configured refspecs will be used
 *      opts = options to use for this push
 */
//GIT_EXTERN
int git_remote_push(libgit2_d.types.git_remote* remote, const (libgit2_d.strarray.git_strarray)* refspecs, const (.git_push_options)* opts);

/**
 * Get the statistics structure that is filled in by the fetch operation.
 */
//GIT_EXTERN
const (libgit2_d.indexer.git_indexer_progress)* git_remote_stats(libgit2_d.types.git_remote* remote);

/**
 * Retrieve the tag auto-follow setting
 *
 * Params:
 *      remote = the remote to query
 *
 * Returns: the auto-follow setting
 */
//GIT_EXTERN
.git_remote_autotag_option_t git_remote_autotag(const (libgit2_d.types.git_remote)* remote);

/**
 * Set the remote's tag following setting.
 *
 * The change will be made in the configuration. No loaded remotes
 * will be affected.
 *
 * Params:
 *      repo = the repository in which to make the change
 *      remote = the name of the remote
 *      value = the new value to take.
 */
//GIT_EXTERN
int git_remote_set_autotag(libgit2_d.types.git_repository* repo, const (char)* remote, .git_remote_autotag_option_t value);

/**
 * Retrieve the ref-prune setting
 *
 * Params:
 *      remote = the remote to query
 *
 * Returns: the ref-prune setting
 */
//GIT_EXTERN
int git_remote_prune_refs(const (libgit2_d.types.git_remote)* remote);

/**
 * Give the remote a new name
 *
 * All remote-tracking branches and configuration settings
 * for the remote are updated.
 *
 * The new name will be checked for validity.
 * See `git_tag_create()` for rules about valid names.
 *
 * No loaded instances of a the remote with the old name will change
 * their name or their list of refspecs.
 *
 * Params:
 *      problems = non-default refspecs cannot be renamed and will be stored here for further processing by the caller. Always free this strarray on successful return.
 *      repo = the repository in which to rename
 *      name = the current name of the remote
 *      new_name = the new name the remote should bear
 *
 * Returns: 0, git_error_code.GIT_EINVALIDSPEC, git_error_code.GIT_EEXISTS or an error code
 */
//GIT_EXTERN
int git_remote_rename(libgit2_d.strarray.git_strarray* problems, libgit2_d.types.git_repository* repo, const (char)* name, const (char)* new_name);

/**
 * Ensure the remote name is well-formed.
 *
 * Params:
 *      remote_name = name to be checked.
 *
 * Returns: 1 if the reference name is acceptable; 0 if it isn't
 */
//GIT_EXTERN
int git_remote_is_valid_name(const (char)* remote_name);

/**
 * Delete an existing persisted remote.
 *
 * All remote-tracking branches and configuration settings
 * for the remote will be removed.
 *
 * Params:
 *      repo = the repository in which to act
 *      name = the name of the remote to delete
 *
 * Returns: 0 on success, or an error code.
 */
//GIT_EXTERN
int git_remote_delete(libgit2_d.types.git_repository* repo, const (char)* name);

/**
 * Retrieve the name of the remote's default branch
 *
 * The default branch of a repository is the branch which HEAD points
 * to. If the remote does not support reporting this information
 * directly, it performs the guess as git does; that is, if there are
 * multiple branches which point to the same commit, the first one is
 * chosen. If the master branch is a candidate, it wins.
 *
 * This function must only be called after connecting.
 *
 * Params:
 *      out_ = the buffern in which to store the reference name
 *      remote = the remote
 *
 * Returns: 0, git_error_code.GIT_ENOTFOUND if the remote does not have any references or none of them point to HEAD's commit, or an error message.
 */
//GIT_EXTERN
int git_remote_default_branch(libgit2_d.buffer.git_buf* out_, libgit2_d.types.git_remote* remote);

/* @} */
