/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.deprecated_;


private static import libgit2_d.attr;
private static import libgit2_d.blame;
private static import libgit2_d.buffer;
private static import libgit2_d.checkout;
private static import libgit2_d.cherrypick;
private static import libgit2_d.clone;
private static import libgit2_d.config;
private static import libgit2_d.credential;
private static import libgit2_d.credential_helpers;
private static import libgit2_d.describe;
private static import libgit2_d.diff;
private static import libgit2_d.errors;
private static import libgit2_d.index;
private static import libgit2_d.indexer;
private static import libgit2_d.merge;
private static import libgit2_d.oid;
private static import libgit2_d.proxy;
private static import libgit2_d.rebase;
private static import libgit2_d.refs;
private static import libgit2_d.remote;
private static import libgit2_d.repository;
private static import libgit2_d.revert;
private static import libgit2_d.stash;
private static import libgit2_d.status;
private static import libgit2_d.strarray;
private static import libgit2_d.submodule;
private static import libgit2_d.trace;
private static import libgit2_d.types;
private static import libgit2_d.worktree;

extern (C):
nothrow @nogc:
public:
deprecated:

/*
 * Users can avoid deprecated functions by defining `GIT_DEPRECATE_HARD`.
 */
version (GIT_DEPRECATE_HARD) {
} else {
	/*
	 * The credential structures are now opaque by default, and their
	 * definition has moved into the `sys/credential.h` header; include
	 * them here for backward compatibility.
	 */
	//public import import libgit2_d.credential;

	/**
	 * @file git2/deprecated.h
	 * @brief libgit2 deprecated functions and values
	 * @ingroup Git
	 * @{
	 */

	/** @name Deprecated Attribute Constants
	 *
	 * These enumeration values are retained for backward compatibility.
	 * The newer versions of these functions should be preferred in all
	 * new code.
	 *
	 * There is no plan to remove these backward compatibility values at
	 * this time.
	 */
	/**@{*/

	enum GIT_ATTR_UNSPECIFIED_T = libgit2_d.attr.git_attr_value_t.GIT_ATTR_VALUE_UNSPECIFIED;
	enum GIT_ATTR_TRUE_T = libgit2_d.attr.git_attr_value_t.GIT_ATTR_VALUE_TRUE;
	enum GIT_ATTR_FALSE_T = libgit2_d.attr.git_attr_value_t.GIT_ATTR_VALUE_FALSE;
	enum GIT_ATTR_VALUE_T = libgit2_d.attr.git_attr_value_t.GIT_ATTR_VALUE_STRING;

	version (none) {
		alias GIT_ATTR_TRUE = GIT_ATTR_IS_TRUE;
		alias GIT_ATTR_FALSE = GIT_ATTR_IS_FALSE;
		alias GIT_ATTR_UNSPECIFIED = GIT_ATTR_IS_UNSPECIFIED;
	}

	alias git_attr_t = libgit2_d.attr.git_attr_value_t;

	/**@}*/

	/** @name Deprecated Blob Functions
	 *
	 * These functions are retained for backward compatibility.  The newer
	 * versions of these functions should be preferred in all new code.
	 *
	 * There is no plan to remove these backward compatibility values at
	 * this time.
	 */
	/**@{*/

	//GIT_EXTERN
	int git_blob_create_fromworkdir(libgit2_d.oid.git_oid* id, libgit2_d.types.git_repository* repo, const (char)* relative_path);

	//GIT_EXTERN
	int git_blob_create_fromdisk(libgit2_d.oid.git_oid* id, libgit2_d.types.git_repository* repo, const (char)* path);

	//GIT_EXTERN
	int git_blob_create_fromstream(libgit2_d.types.git_writestream** out_, libgit2_d.types.git_repository* repo, const (char)* hintpath);

	//GIT_EXTERN
	int git_blob_create_fromstream_commit(libgit2_d.oid.git_oid* out_, libgit2_d.types.git_writestream* stream);

	//GIT_EXTERN
	int git_blob_create_frombuffer(libgit2_d.oid.git_oid* id, libgit2_d.types.git_repository* repo, const (void)* buffer, size_t len);

	/** Deprecated in favor of `git_blob_filter`.
	 *
	 * @deprecated Use git_blob_filter
	 * @see git_blob_filter
	 */
	//GIT_EXTERN
	int git_blob_filtered_content(libgit2_d.buffer.git_buf* out_, libgit2_d.types.git_blob* blob, const (char)* as_path, int check_for_binary_data);

	/**@}*/

	/** @name Deprecated Buffer Functions
	 *
	 * These functions and enumeration values are retained for backward
	 * compatibility.  The newer versions of these functions should be
	 * preferred in all new code.
	 *
	 * There is no plan to remove these backward compatibility values at
	 * this time.
	 */
	/**@{*/

	/**
	 * Free the memory referred to by the git_buf.  This is an alias of
	 * `git_buf_dispose` and is preserved for backward compatibility.
	 *
	 * This function is deprecated, but there is no plan to remove this
	 * function at this time.
	 *
	 * @deprecated Use git_buf_dispose
	 * @see git_buf_dispose
	 */
	//GIT_EXTERN
	void git_buf_free(libgit2_d.buffer.git_buf* buffer);

	/**@}*/

	/** @name Deprecated Config Functions and Constants
	 */
	/**@{*/

	enum GIT_CVAR_FALSE = libgit2_d.config.git_configmap_t.GIT_CONFIGMAP_FALSE;
	enum GIT_CVAR_TRUE = libgit2_d.config.git_configmap_t.GIT_CONFIGMAP_TRUE;
	enum GIT_CVAR_INT32 = libgit2_d.config.git_configmap_t.GIT_CONFIGMAP_INT32;
	enum GIT_CVAR_STRING = libgit2_d.config.git_configmap_t.GIT_CONFIGMAP_STRING;

	alias git_cvar_map = libgit2_d.config.git_configmap;

	/**@}*/

	/** @name Deprecated Error Functions and Constants
	 *
	 * These functions and enumeration values are retained for backward
	 * compatibility.  The newer versions of these functions and values
	 * should be preferred in all new code.
	 *
	 * There is no plan to remove these backward compatibility values at
	 * this time.
	 */
	/**@{*/

	enum GITERR_NONE = libgit2_d.errors.git_error_t.GIT_ERROR_NONE;
	enum GITERR_NOMEMORY = libgit2_d.errors.git_error_t.GIT_ERROR_NOMEMORY;
	enum GITERR_OS = libgit2_d.errors.git_error_t.GIT_ERROR_OS;
	enum GITERR_INVALID = libgit2_d.errors.git_error_t.GIT_ERROR_INVALID;
	enum GITERR_REFERENCE = libgit2_d.errors.git_error_t.GIT_ERROR_REFERENCE;
	enum GITERR_ZLIB = libgit2_d.errors.git_error_t.GIT_ERROR_ZLIB;
	enum GITERR_REPOSITORY = libgit2_d.errors.git_error_t.GIT_ERROR_REPOSITORY;
	enum GITERR_CONFIG = libgit2_d.errors.git_error_t.GIT_ERROR_CONFIG;
	enum GITERR_REGEX = libgit2_d.errors.git_error_t.GIT_ERROR_REGEX;
	enum GITERR_ODB = libgit2_d.errors.git_error_t.GIT_ERROR_ODB;
	enum GITERR_INDEX = libgit2_d.errors.git_error_t.GIT_ERROR_INDEX;
	enum GITERR_OBJECT = libgit2_d.errors.git_error_t.GIT_ERROR_OBJECT;
	enum GITERR_NET = libgit2_d.errors.git_error_t.GIT_ERROR_NET;
	enum GITERR_TAG = libgit2_d.errors.git_error_t.GIT_ERROR_TAG;
	enum GITERR_TREE = libgit2_d.errors.git_error_t.GIT_ERROR_TREE;
	enum GITERR_INDEXER = libgit2_d.errors.git_error_t.GIT_ERROR_INDEXER;
	enum GITERR_SSL = libgit2_d.errors.git_error_t.GIT_ERROR_SSL;
	enum GITERR_SUBMODULE = libgit2_d.errors.git_error_t.GIT_ERROR_SUBMODULE;
	enum GITERR_THREAD = libgit2_d.errors.git_error_t.GIT_ERROR_THREAD;
	enum GITERR_STASH = libgit2_d.errors.git_error_t.GIT_ERROR_STASH;
	enum GITERR_CHECKOUT = libgit2_d.errors.git_error_t.GIT_ERROR_CHECKOUT;
	enum GITERR_FETCHHEAD = libgit2_d.errors.git_error_t.GIT_ERROR_FETCHHEAD;
	enum GITERR_MERGE = libgit2_d.errors.git_error_t.GIT_ERROR_MERGE;
	enum GITERR_SSH = libgit2_d.errors.git_error_t.GIT_ERROR_SSH;
	enum GITERR_FILTER = libgit2_d.errors.git_error_t.GIT_ERROR_FILTER;
	enum GITERR_REVERT = libgit2_d.errors.git_error_t.GIT_ERROR_REVERT;
	enum GITERR_CALLBACK = libgit2_d.errors.git_error_t.GIT_ERROR_CALLBACK;
	enum GITERR_CHERRYPICK = libgit2_d.errors.git_error_t.GIT_ERROR_CHERRYPICK;
	enum GITERR_DESCRIBE = libgit2_d.errors.git_error_t.GIT_ERROR_DESCRIBE;
	enum GITERR_REBASE = libgit2_d.errors.git_error_t.GIT_ERROR_REBASE;
	enum GITERR_FILESYSTEM = libgit2_d.errors.git_error_t.GIT_ERROR_FILESYSTEM;
	enum GITERR_PATCH = libgit2_d.errors.git_error_t.GIT_ERROR_PATCH;
	enum GITERR_WORKTREE = libgit2_d.errors.git_error_t.GIT_ERROR_WORKTREE;
	enum GITERR_SHA1 = libgit2_d.errors.git_error_t.GIT_ERROR_SHA1;

	/**
	 * Return the last `git_error` object that was generated for the
	 * current thread.  This is an alias of `git_error_last` and is
	 * preserved for backward compatibility.
	 *
	 * This function is deprecated, but there is no plan to remove this
	 * function at this time.
	 *
	 * @deprecated Use git_error_last
	 * @see git_error_last
	 */
	//GIT_EXTERN
	const (libgit2_d.errors.git_error)* giterr_last();

	/**
	 * Clear the last error.  This is an alias of `git_error_last` and is
	 * preserved for backward compatibility.
	 *
	 * This function is deprecated, but there is no plan to remove this
	 * function at this time.
	 *
	 * @deprecated Use git_error_clear
	 * @see git_error_clear
	 */
	//GIT_EXTERN
	void giterr_clear();

	/**
	 * Sets the error message to the given string.  This is an alias of
	 * `git_error_set_str` and is preserved for backward compatibility.
	 *
	 * This function is deprecated, but there is no plan to remove this
	 * function at this time.
	 *
	 * @deprecated Use git_error_set_str
	 * @see git_error_set_str
	 */
	//GIT_EXTERN
	void giterr_set_str(int error_class, const (char)* string_);

	/**
	 * Indicates that an out-of-memory situation occurred.  This is an alias
	 * of `git_error_set_oom` and is preserved for backward compatibility.
	 *
	 * This function is deprecated, but there is no plan to remove this
	 * function at this time.
	 *
	 * @deprecated Use git_error_set_oom
	 * @see git_error_set_oom
	 */
	//GIT_EXTERN
	void giterr_set_oom();

	/**@}*/

	/** @name Deprecated Index Functions and Constants
	 *
	 * These functions and enumeration values are retained for backward
	 * compatibility.  The newer versions of these values should be
	 * preferred in all new code.
	 *
	 * There is no plan to remove these backward compatibility values at
	 * this time.
	 */
	/**@{*/

	enum GIT_IDXENTRY_NAMEMASK = libgit2_d.index.GIT_INDEX_ENTRY_NAMEMASK;
	enum GIT_IDXENTRY_STAGEMASK = libgit2_d.index.GIT_INDEX_ENTRY_STAGEMASK;
	enum GIT_IDXENTRY_STAGESHIFT = libgit2_d.index.GIT_INDEX_ENTRY_STAGESHIFT;

	/* The git_indxentry_flag_t enum */
	enum GIT_IDXENTRY_EXTENDED = libgit2_d.index.git_index_entry_flag_t.GIT_INDEX_ENTRY_EXTENDED;
	enum GIT_IDXENTRY_VALID = libgit2_d.index.git_index_entry_flag_t.GIT_INDEX_ENTRY_VALID;

	alias GIT_IDXENTRY_STAGE = libgit2_d.index.GIT_INDEX_ENTRY_STAGE;
	alias GIT_IDXENTRY_STAGE_SET = libgit2_d.index.GIT_INDEX_ENTRY_STAGE_SET;

	/* The git_idxentry_extended_flag_t enum */
	enum GIT_IDXENTRY_INTENT_TO_ADD = libgit2_d.index.git_index_entry_extended_flag_t.GIT_INDEX_ENTRY_INTENT_TO_ADD;
	enum GIT_IDXENTRY_SKIP_WORKTREE = libgit2_d.index.git_index_entry_extended_flag_t.GIT_INDEX_ENTRY_SKIP_WORKTREE;
	enum GIT_IDXENTRY_EXTENDED_FLAGS = libgit2_d.index.git_index_entry_extended_flag_t.GIT_INDEX_ENTRY_INTENT_TO_ADD | libgit2_d.index.git_index_entry_extended_flag_t.GIT_INDEX_ENTRY_SKIP_WORKTREE;
	enum GIT_IDXENTRY_EXTENDED2 = 1 << 15;
	enum GIT_IDXENTRY_UPDATE = 1 << 0;
	enum GIT_IDXENTRY_REMOVE = 1 << 1;
	enum GIT_IDXENTRY_UPTODATE = 1 << 2;
	enum GIT_IDXENTRY_ADDED = 1 << 3;
	enum GIT_IDXENTRY_HASHED = 1 << 4;
	enum GIT_IDXENTRY_UNHASHED = 1 << 5;
	enum GIT_IDXENTRY_WT_REMOVE = 1 << 6;
	enum GIT_IDXENTRY_CONFLICTED = 1 << 7;
	enum GIT_IDXENTRY_UNPACKED = 1 << 8;
	enum GIT_IDXENTRY_NEW_SKIP_WORKTREE = 1 << 9;

	/* The git_index_capability_t enum */
	enum GIT_INDEXCAP_IGNORE_CASE = libgit2_d.index.git_index_capability_t.GIT_INDEX_CAPABILITY_IGNORE_CASE;
	enum GIT_INDEXCAP_NO_FILEMODE = libgit2_d.index.git_index_capability_t.GIT_INDEX_CAPABILITY_NO_FILEMODE;
	enum GIT_INDEXCAP_NO_SYMLINKS = libgit2_d.index.git_index_capability_t.GIT_INDEX_CAPABILITY_NO_SYMLINKS;
	enum GIT_INDEXCAP_FROM_OWNER = libgit2_d.index.git_index_capability_t.GIT_INDEX_CAPABILITY_FROM_OWNER;

	//GIT_EXTERN
	int git_index_add_frombuffer(libgit2_d.types.git_index* index, const (libgit2_d.index.git_index_entry)* entry, const (void)* buffer, size_t len);

	/**@}*/

	/** @name Deprecated Object Constants
	 *
	 * These enumeration values are retained for backward compatibility.  The
	 * newer versions of these values should be preferred in all new code.
	 *
	 * There is no plan to remove these backward compatibility values at
	 * this time.
	 */
	/**@{*/

	alias git_otype = libgit2_d.types.git_object_t;

	enum GIT_OBJ_ANY = libgit2_d.types.git_object_t.GIT_OBJECT_ANY;
	enum GIT_OBJ_BAD = libgit2_d.types.git_object_t.GIT_OBJECT_INVALID;
	enum GIT_OBJ__EXT1 = 0;
	enum GIT_OBJ_COMMIT = libgit2_d.types.git_object_t.GIT_OBJECT_COMMIT;
	enum GIT_OBJ_TREE = libgit2_d.types.git_object_t.GIT_OBJECT_TREE;
	enum GIT_OBJ_BLOB = libgit2_d.types.git_object_t.GIT_OBJECT_BLOB;
	enum GIT_OBJ_TAG = libgit2_d.types.git_object_t.GIT_OBJECT_TAG;
	enum GIT_OBJ__EXT2 = 5;
	enum GIT_OBJ_OFS_DELTA = libgit2_d.types.git_object_t.GIT_OBJECT_OFS_DELTA;
	enum GIT_OBJ_REF_DELTA = libgit2_d.types.git_object_t.GIT_OBJECT_REF_DELTA;

	/**
	 * Get the size in bytes for the structure which
	 * acts as an in-memory representation of any given
	 * object type.
	 *
	 * For all the core types, this would the equivalent
	 * of calling `sizeof(git_commit)` if the core types
	 * were not opaque on the external API.
	 *
	 * Params:
	 *      type = object type to get its size
	 *
	 * Returns: size in bytes of the object
	 */
	//GIT_EXTERN
	size_t git_object__size(libgit2_d.types.git_object_t type);

	/**@}*/

	/** @name Deprecated Reference Constants
	 *
	 * These enumeration values are retained for backward compatibility.  The
	 * newer versions of these values should be preferred in all new code.
	 *
	 * There is no plan to remove these backward compatibility values at
	 * this time.
	 */
	/**@{*/

	/** Basic type of any Git reference. */
	alias git_ref_t = libgit2_d.types.git_reference_t;
	alias git_reference_normalize_t = libgit2_d.refs.git_reference_format_t;

	enum GIT_REF_INVALID = libgit2_d.types.git_reference_t.GIT_REFERENCE_INVALID;
	enum GIT_REF_OID = libgit2_d.types.git_reference_t.GIT_REFERENCE_DIRECT;
	enum GIT_REF_SYMBOLIC = libgit2_d.types.git_reference_t.GIT_REFERENCE_SYMBOLIC;
	enum GIT_REF_LISTALL = libgit2_d.types.git_reference_t.GIT_REFERENCE_ALL;

	enum GIT_REF_FORMAT_NORMAL = libgit2_d.refs.git_reference_format_t.GIT_REFERENCE_FORMAT_NORMAL;
	enum GIT_REF_FORMAT_ALLOW_ONELEVEL = libgit2_d.refs.git_reference_format_t.GIT_REFERENCE_FORMAT_ALLOW_ONELEVEL;
	enum GIT_REF_FORMAT_REFSPEC_PATTERN = libgit2_d.refs.git_reference_format_t.GIT_REFERENCE_FORMAT_REFSPEC_PATTERN;
	enum GIT_REF_FORMAT_REFSPEC_SHORTHAND = libgit2_d.refs.git_reference_format_t.GIT_REFERENCE_FORMAT_REFSPEC_SHORTHAND;

	//GIT_EXTERN
	int git_tag_create_frombuffer(libgit2_d.oid.git_oid* oid, libgit2_d.types.git_repository* repo, const (char)* buffer, int force);

	/**@}*/

	/** @name Deprecated Credential Types
	 *
	 * These types are retained for backward compatibility.  The newer
	 * versions of these values should be preferred in all new code.
	 *
	 * There is no plan to remove these backward compatibility values at
	 * this time.
	 */

	alias git_cred = libgit2_d.credential.git_credential;
	alias git_cred_userpass_plaintext = libgit2_d.credential.git_credential_userpass_plaintext;
	alias git_cred_username = libgit2_d.credential.git_credential_username;
	alias git_cred_default = libgit2_d.credential.git_credential_default;
	alias git_cred_ssh_key = libgit2_d.credential.git_credential_ssh_key;
	alias git_cred_ssh_interactive = libgit2_d.credential.git_credential_ssh_interactive;
	alias git_cred_ssh_custom = libgit2_d.credential.git_credential_ssh_custom;

	alias git_cred_acquire_cb = libgit2_d.credential.git_credential_acquire_cb;
	alias git_cred_sign_callback = libgit2_d.credential.git_credential_sign_cb;
	alias git_cred_sign_cb = libgit2_d.credential.git_credential_sign_cb;
	alias git_cred_ssh_interactive_callback = libgit2_d.credential.git_credential_ssh_interactive_cb;
	alias git_cred_ssh_interactive_cb = libgit2_d.credential.git_credential_ssh_interactive_cb;

	alias git_credtype_t = libgit2_d.credential.git_credential_t;

	alias GIT_CREDTYPE_USERPASS_PLAINTEXT = libgit2_d.credential.git_credential_t.GIT_CREDENTIAL_USERPASS_PLAINTEXT;
	alias GIT_CREDTYPE_SSH_KEY = libgit2_d.credential.git_credential_t.GIT_CREDENTIAL_SSH_KEY;
	alias GIT_CREDTYPE_SSH_CUSTOM = libgit2_d.credential.git_credential_t.GIT_CREDENTIAL_SSH_CUSTOM;
	alias GIT_CREDTYPE_DEFAULT = libgit2_d.credential.git_credential_t.GIT_CREDENTIAL_DEFAULT;
	alias GIT_CREDTYPE_SSH_INTERACTIVE = libgit2_d.credential.git_credential_t.GIT_CREDENTIAL_SSH_INTERACTIVE;
	alias GIT_CREDTYPE_USERNAME = libgit2_d.credential.git_credential_t.GIT_CREDENTIAL_USERNAME;
	alias GIT_CREDTYPE_SSH_MEMORY = libgit2_d.credential.git_credential_t.GIT_CREDENTIAL_SSH_MEMORY;

	//GIT_EXTERN
	void git_cred_free(libgit2_d.credential.git_credential* cred);

	//GIT_EXTERN
	int git_cred_has_username(libgit2_d.credential.git_credential* cred);

	//GIT_EXTERN
	const (char)* git_cred_get_username(libgit2_d.credential.git_credential* cred);

	//GIT_EXTERN
	int git_cred_userpass_plaintext_new(libgit2_d.credential.git_credential** out_, const (char)* username, const (char)* password);

	//GIT_EXTERN
	int git_cred_default_new(libgit2_d.credential.git_credential** out_);

	//GIT_EXTERN
	int git_cred_username_new(libgit2_d.credential.git_credential** out_, const (char)* username);

	//GIT_EXTERN
	int git_cred_ssh_key_new(libgit2_d.credential.git_credential** out_, const (char)* username, const (char)* publickey, const (char)* privatekey, const (char)* passphrase);

	//GIT_EXTERN
	int git_cred_ssh_key_memory_new(libgit2_d.credential.git_credential** out_, const (char)* username, const (char)* publickey, const (char)* privatekey, const (char)* passphrase);

	//GIT_EXTERN
	int git_cred_ssh_interactive_new(libgit2_d.credential.git_credential** out_, const (char)* username, libgit2_d.credential.git_credential_ssh_interactive_cb prompt_callback, void* payload);

	//GIT_EXTERN
	int git_cred_ssh_key_from_agent(libgit2_d.credential.git_credential** out_, const (char)* username);

	//GIT_EXTERN
	int git_cred_ssh_custom_new(libgit2_d.credential.git_credential** out_, const (char)* username, const (char)* publickey, size_t publickey_len, libgit2_d.credential.git_credential_sign_cb sign_callback, void* payload);

	/* Deprecated Credential Helper Types */

	alias git_cred_userpass_payload = libgit2_d.credential_helpers.git_credential_userpass_payload;

	//GIT_EXTERN
	int git_cred_userpass(libgit2_d.credential.git_credential** out_, const (char)* url, const (char)* user_from_url, uint allowed_types, void* payload);

	/**@}*/

	/** @name Deprecated Trace Callback Types
	 *
	 * These types are retained for backward compatibility.  The newer
	 * versions of these values should be preferred in all new code.
	 *
	 * There is no plan to remove these backward compatibility values at
	 * this time.
	 */
	/**@{*/

	alias git_trace_callback = libgit2_d.trace.git_trace_cb;

	/**@}*/

	/** @name Deprecated Object ID Types
	 *
	 * These types are retained for backward compatibility.  The newer
	 * versions of these values should be preferred in all new code.
	 *
	 * There is no plan to remove these backward compatibility values at
	 * this time.
	 */
	/**@{*/

	//GIT_EXTERN
	int git_oid_iszero(const (libgit2_d.oid.git_oid)* id);

	/**@}*/

	/** @name Deprecated Transfer Progress Types
	 *
	 * These types are retained for backward compatibility.  The newer
	 * versions of these values should be preferred in all new code.
	 *
	 * There is no plan to remove these backward compatibility values at
	 * this time.
	 */
	/**@{*/

	/**
	 * This structure is used to provide callers information about the
	 * progress of indexing a packfile.
	 *
	 * This type is deprecated, but there is no plan to remove this
	 * type definition at this time.
	 */
	alias git_transfer_progress = libgit2_d.indexer.git_indexer_progress;

	/**
	 * Type definition for progress callbacks during indexing.
	 *
	 * This type is deprecated, but there is no plan to remove this
	 * type definition at this time.
	 */
	alias git_transfer_progress_cb = libgit2_d.indexer.git_indexer_progress_cb;

	/**
	 * Type definition for push transfer progress callbacks.
	 *
	 * This type is deprecated, but there is no plan to remove this
	 * type definition at this time.
	 */
	alias git_push_transfer_progress = libgit2_d.remote.git_push_transfer_progress_cb;

	/**
	 * The type of a remote completion event
	 */
	alias git_remote_completion_type = libgit2_d.remote.git_remote_completion_t;

	/**
	 * Callback for listing the remote heads
	 */
	alias git_headlist_cb = int function(libgit2_d.types.git_remote_head* rhead, void* payload);

	/**@}*/

	/** @name Deprecated String Array Functions
	*
	* These types are retained for backward compatibility.  The newer
	* versions of these values should be preferred in all new code.
	*
	* There is no plan to remove these backward compatibility values at
	* this time.
	*/
	/**@{*/

	/**
	* Copy a string array object from source to target.
	*
	* This function is deprecated, but there is no plan to remove this
	* function at this time.
	*
	* @param tgt target
	* @param src source
	* @return 0 on success, < 0 on allocation failure
	*/
	//GIT_EXTERN
	int git_strarray_copy(libgit2_d.strarray.git_strarray* tgt, const (libgit2_d.strarray.git_strarray)* src);

	/**
	* Free the memory referred to by the git_strarray.  This is an alias of
	* `git_strarray_dispose` and is preserved for backward compatibility.
	*
	* This function is deprecated, but there is no plan to remove this
	* function at this time.
	*
	* @deprecated Use git_strarray_dispose
	* @see git_strarray_dispose
	*/
	//GIT_EXTERN
	void git_strarray_free(libgit2_d.strarray.git_strarray* array);

	/**@}*/

	/** @name Deprecated Options Initialization Functions
	 *
	 * These functions are retained for backward compatibility.  The newer
	 * versions of these functions should be preferred in all new code.
	 *
	 * There is no plan to remove these backward compatibility functions at
	 * this time.
	 */
	/**@{*/

	//GIT_EXTERN
	int git_blame_init_options(libgit2_d.blame.git_blame_options* opts, uint version_);

	//GIT_EXTERN
	int git_checkout_init_options(libgit2_d.checkout.git_checkout_options* opts, uint version_);

	//GIT_EXTERN
	int git_cherrypick_init_options(libgit2_d.cherrypick.git_cherrypick_options* opts, uint version_);

	//GIT_EXTERN
	int git_clone_init_options(libgit2_d.clone.git_clone_options* opts, uint version_);

	//GIT_EXTERN
	int git_describe_init_options(libgit2_d.describe.git_describe_options* opts, uint version_);

	//GIT_EXTERN
	int git_describe_init_format_options(libgit2_d.describe.git_describe_format_options* opts, uint version_);

	//GIT_EXTERN
	int git_diff_init_options(libgit2_d.diff.git_diff_options* opts, uint version_);

	//GIT_EXTERN
	int git_diff_find_init_options(libgit2_d.diff.git_diff_find_options* opts, uint version_);

	//GIT_EXTERN
	int git_diff_format_email_init_options(libgit2_d.diff.git_diff_format_email_options* opts, uint version_);

	//GIT_EXTERN
	int git_diff_patchid_init_options(libgit2_d.diff.git_diff_patchid_options* opts, uint version_);

	//GIT_EXTERN
	int git_fetch_init_options(libgit2_d.remote.git_fetch_options* opts, uint version_);

	//GIT_EXTERN
	int git_indexer_init_options(libgit2_d.indexer.git_indexer_options* opts, uint version_);

	//GIT_EXTERN
	int git_merge_init_options(libgit2_d.merge.git_merge_options* opts, uint version_);

	//GIT_EXTERN
	int git_merge_file_init_input(libgit2_d.merge.git_merge_file_input* input, uint version_);

	//GIT_EXTERN
	int git_merge_file_init_options(libgit2_d.merge.git_merge_file_options* opts, uint version_);

	//GIT_EXTERN
	int git_proxy_init_options(libgit2_d.proxy.git_proxy_options* opts, uint version_);

	//GIT_EXTERN
	int git_push_init_options(libgit2_d.remote.git_push_options* opts, uint version_);

	//GIT_EXTERN
	int git_rebase_init_options(libgit2_d.rebase.git_rebase_options* opts, uint version_);

	//GIT_EXTERN
	int git_remote_create_init_options(libgit2_d.remote.git_remote_create_options* opts, uint version_);

	//GIT_EXTERN
	int git_repository_init_init_options(libgit2_d.repository.git_repository_init_options* opts, uint version_);

	//GIT_EXTERN
	int git_revert_init_options(libgit2_d.revert.git_revert_options* opts, uint version_);

	//GIT_EXTERN
	int git_stash_apply_init_options(libgit2_d.stash.git_stash_apply_options* opts, uint version_);

	//GIT_EXTERN
	int git_status_init_options(libgit2_d.status.git_status_options* opts, uint version_);

	//GIT_EXTERN
	int git_submodule_update_init_options(libgit2_d.submodule.git_submodule_update_options* opts, uint version_);

	//GIT_EXTERN
	int git_worktree_add_init_options(libgit2_d.worktree.git_worktree_add_options* opts, uint version_);

	//GIT_EXTERN
	int git_worktree_prune_init_options(libgit2_d.worktree.git_worktree_prune_options* opts, uint version_);

	/**@}*/

	/** @} */
}
