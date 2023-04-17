/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2.attr;


private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/attr.h
 * @brief Git attribute management routines
 * @defgroup git_attr Git attribute management routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

//Linker error
version (none) {
	/**
	 * GIT_ATTR_TRUE checks if an attribute is set on.  In core git
	 * parlance, this the value for "Set" attributes.
	 *
	 * For example, if the attribute file contains:
	 *
	 *    *.c foo
	 *
	 * Then for file `xyz.c` looking up attribute "foo" gives a value for
	 * which `GIT_ATTR_TRUE(value)` is true.
	 */
	pragma(inline, true)
	nothrow @nogc
	bool GIT_ATTR_IS_TRUE(const (char)* attr)

		do
		{
			return .git_attr_value(attr) == .git_attr_t.GIT_ATTR_VALUE_TRUE;
		}

	/**
	 * GIT_ATTR_FALSE checks if an attribute is set off.  In core git
	 * parlance, this is the value for attributes that are "Unset" (not to
	 * be confused with values that a "Unspecified").
	 *
	 * For example, if the attribute file contains:
	 *
	 *    *.h -foo
	 *
	 * Then for file `zyx.h` looking up attribute "foo" gives a value for
	 * which `GIT_ATTR_FALSE(value)` is true.
	 */
	pragma(inline, true)
	nothrow @nogc
	bool GIT_ATTR_IS_FALSE(const (char)* attr)

		do
		{
			return .git_attr_value(attr) == .git_attr_t.GIT_ATTR_VALUE_FALSE;
		}

	/**
	 * GIT_ATTR_UNSPECIFIED checks if an attribute is unspecified.  This
	 * may be due to the attribute not being mentioned at all or because
	 * the attribute was explicitly set unspecified via the `!` operator.
	 *
	 * For example, if the attribute file contains:
	 *
	 *    *.c foo
	 *    *.h -foo
	 *    onefile.c !foo
	 *
	 * Then for `onefile.c` looking up attribute "foo" yields a value with
	 * `GIT_ATTR_UNSPECIFIED(value)` of true.  Also, looking up "foo" on
	 * file `onefile.rb` or looking up "bar" on any file will all give
	 * `GIT_ATTR_UNSPECIFIED(value)` of true.
	 */
	pragma(inline, true)
	nothrow @nogc
	bool GIT_ATTR_IS_UNSPECIFIED(const (char)* attr)

		do
		{
			return .git_attr_value(attr) == .git_attr_t.GIT_ATTR_VALUE_UNSPECIFIED;
		}

	/**
	 * GIT_ATTR_HAS_VALUE checks if an attribute is set to a value (as
	 * opposed to TRUE, FALSE or UNSPECIFIED).  This would be the case if
	 * for a file with something like:
	 *
	 *    *.txt eol=lf
	 *
	 * Given this, looking up "eol" for `onefile.txt` will give back the
	 * string "lf" and `GIT_ATTR_SET_TO_VALUE(attr)` will return true.
	 */
	pragma(inline, true)
	nothrow @nogc
	bool GIT_ATTR_HAS_VALUE(const (char)* attr)

		do
		{
			return .git_attr_value(attr) == .git_attr_t.GIT_ATTR_VALUE_STRING;
		}
}

/**
 * Possible states for an attribute
 */
enum git_attr_value_t
{
	/**
	 * The attribute has been left unspecified
	 */
	GIT_ATTR_VALUE_UNSPECIFIED = 0,

	/**
	 * The attribute has been set
	 */
	GIT_ATTR_VALUE_TRUE,

	/**
	 * The attribute has been unset
	 */
	GIT_ATTR_VALUE_FALSE,

	/**
	 * This attribute has a value
	 */
	GIT_ATTR_VALUE_STRING,
}

//Declaration name in C language
enum
{
	GIT_ATTR_VALUE_UNSPECIFIED = .git_attr_value_t.GIT_ATTR_VALUE_UNSPECIFIED,
	GIT_ATTR_VALUE_TRUE = .git_attr_value_t.GIT_ATTR_VALUE_TRUE,
	GIT_ATTR_VALUE_FALSE = .git_attr_value_t.GIT_ATTR_VALUE_FALSE,
	GIT_ATTR_VALUE_STRING = .git_attr_value_t.GIT_ATTR_VALUE_STRING,
}

/**
 * Return the value type for a given attribute.
 *
 * This can be either `TRUE`, `FALSE`, `UNSPECIFIED` (if the attribute
 * was not set at all), or `VALUE`, if the attribute was set to an
 * actual string.
 *
 * If the attribute has a `VALUE` string, it can be accessed normally
 * as a null-terminated C string.
 *
 * Params:
 *      attr = The attribute
 *
 * Returns: the value type for the attribute
 */
@GIT_EXTERN
.git_attr_value_t git_attr_value(const (char)* attr);

/**
 * Check attribute flags: Reading values from index and working directory.
 *
 * When checking attributes, it is possible to check attribute files
 * in both the working directory (if there is one) and the index (if
 * there is one).  You can explicitly choose where to check and in
 * which order using the following flags.
 *
 * Core git usually checks the working directory then the index,
 * except during a checkout when it checks the index first.  It will
 * use index only for creating archives or for a bare repo (if an
 * index has been specified for the bare repo).
 */
enum GIT_ATTR_CHECK_FILE_THEN_INDEX = 0;
enum GIT_ATTR_CHECK_INDEX_THEN_FILE = 1;
enum GIT_ATTR_CHECK_INDEX_ONLY = 2;

/**
 * Check attribute flags: controlling extended attribute behavior.
 *
 * Normally, attribute checks include looking in the /etc (or system
 * equivalent) directory for a `gitattributes` file.  Passing this
 * flag will cause attribute checks to ignore that file.
 * equivalent\) directory for a `gitattributes` file.  Passing the
 * `GIT_ATTR_CHECK_NO_SYSTEM` flag will cause attribute checks to
 * ignore that file.
 *
 * Passing the `GIT_ATTR_CHECK_INCLUDE_HEAD` flag will use attributes
 * from a `.gitattributes` file in the repository at the HEAD revision.
 */
enum GIT_ATTR_CHECK_NO_SYSTEM = 1 << 2;
enum GIT_ATTR_CHECK_INCLUDE_HEAD = 1 << 3;

/**
 * Look up the value of one git attribute for path.
 *
 * Params:
 *      value_out = Output of the value of the attribute.  Use the GIT_ATTR_... macros to test for TRUE, FALSE, UNSPECIFIED, etc. or just use the string value for attributes set to a value.  You should NOT modify or free this value.
 *      repo = The repository containing the path.
 *      flags = A combination of GIT_ATTR_CHECK... flags.
 *      path = The path to check for attributes.  Relative paths are interpreted relative to the repo root.  The file does not have to exist, but if it does not, then it will be treated as a plain file (not a directory).
 *      name = The name of the attribute to look up.
 */
@GIT_EXTERN
int git_attr_get(const (char)** value_out, libgit2.types.git_repository* repo, uint flags, const (char)* path, const (char)* name);

/**
 * Look up a list of git attributes for path.
 *
 * Use this if you have a known list of attributes that you want to
 * look up in a single call.  This is somewhat more efficient than
 * calling `git_attr_get()` multiple times.
 *
 * For example, you might write:
 *
 *     const char *attrs[] = { "crlf", "diff", "foo" };
 *     const char **values[3];
 *     git_attr_get_many(values, repo, 0, "my/fun/file.c", 3, attrs);
 *
 * Then you could loop through the 3 values to get the settings for
 * the three attributes you asked about.
 *
 * Params:
 *      values_out = An array of num_attr entries that will have string pointers written into it for the values of the attributes. You should not modify or free the values that are written into this array (although of course, you should free the array itself if you allocated it).
 *      repo = The repository containing the path.
 *      flags = A combination of GIT_ATTR_CHECK... flags.
 *      path = The path inside the repo to check attributes.  This does not have to exist, but if it does not, then it will be treated as a plain file (i.e. not a directory).
 *      num_attr = The number of attributes being looked up
 *      names = An array of num_attr strings containing attribute names.
 */
@GIT_EXTERN
int git_attr_get_many(const (char)** values_out, libgit2.types.git_repository* repo, uint flags, const (char)* path, size_t num_attr, const (char)** names);

/**
 * The callback used with git_attr_foreach.
 *
 * This callback will be invoked only once per attribute name, even if there
 * are multiple rules for a given file. The highest priority rule will be
 * used.
 *
 * @see git_attr_foreach.
 *
 * Returns: 0 to continue looping, non-zero to stop. This value will be returned from git_attr_foreach.
 */
/*
 * Params:
 *      name = The attribute name.
 *      value = The attribute value. May be NULL if the attribute is explicitly set to UNSPECIFIED using the '!' sign.
 *      payload = A user-specified pointer.
 */
alias git_attr_foreach_cb = int function(const (char)* name, const (char)* value, void* payload);

/**
 * Loop over all the git attributes for a path.
 *
 * Params:
 *      repo = The repository containing the path.
 *      flags = A combination of GIT_ATTR_CHECK... flags.
 *      path = Path inside the repo to check attributes.  This does not have to exist, but if it does not, then it will be treated as a plain file (i.e. not a directory).
 *      callback = Function to invoke on each attribute name and value. See git_attr_foreach_cb.
 *      payload = Passed on as extra parameter to callback function.
 *
 * Returns: 0 on success, non-zero callback return value, or error code
 */
@GIT_EXTERN
int git_attr_foreach(libgit2.types.git_repository* repo, uint flags, const (char)* path, .git_attr_foreach_cb callback, void* payload);

/**
 * Flush the gitattributes cache.
 *
 * Call this if you have reason to believe that the attributes files on
 * disk no longer match the cached contents of memory.  This will cause
 * the attributes files to be reloaded the next time that an attribute
 * access function is called.
 *
 * Params:
 *      repo = The repository containing the gitattributes cache
 *
 * Returns: 0 on success, or an error code
 */
@GIT_EXTERN
int git_attr_cache_flush(libgit2.types.git_repository* repo);

/**
 * Add a macro definition.
 *
 * Macros will automatically be loaded from the top level `.gitattributes`
 * file of the repository (plus the build-in "binary" macro).  This
 * function allows you to add others.  For example, to add the default
 * macro, you would call:
 *
 *     git_attr_add_macro(repo, "binary", "-diff -crlf");
 */
@GIT_EXTERN
int git_attr_add_macro(libgit2.types.git_repository* repo, const (char)* name, const (char)* values);

/* @} */
