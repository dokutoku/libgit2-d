/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.version_;


public:

/**
 * The version string for libgit2.  This string follows semantic
 * versioning (v2) guidelines.
 */
enum LIBGIT2_VERSION = "1.5.2";

/**
 * The major version number for this version of libgit2.
 */
enum LIBGIT2_VER_MAJOR = 1;

/**
 * The minor version number for this version of libgit2.
 */
enum LIBGIT2_VER_MINOR = 5;

/**
 * The revision ("teeny") version number for this version of libgit2.
 */
enum LIBGIT2_VER_REVISION = 2;

/**
 * The Windows DLL patch number for this version of libgit2.
 */
enum LIBGIT2_VER_PATCH = 0;

/**
 * The prerelease string for this version of libgit2.  For development
 * (nightly) builds, this will be "alpha".  For prereleases, this will be
 * a prerelease name like "beta" or "rc1".  For final releases, this will
 * be `null`.
 */
enum LIBGIT2_VER_PRERELEASE = null;

/**
 * The library ABI soversion for this version of libgit2.
 */
enum LIBGIT2_SOVERSION = "1.5";
