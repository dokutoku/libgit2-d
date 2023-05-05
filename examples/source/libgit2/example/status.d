/*
 * libgit2 "status" example - shows how to use the status APIs
 *
 * Written by the libgit2 contributors
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along
 * with this software. If not, see
 * <https://creativecommons.org/publicdomain/zero/1.0/>.
 */
/**
 * This example demonstrates the use of the libgit2 status APIs,
 * particularly the `libgit2.types.git_status_list` object, to roughly simulate the
 * output of running `git status`.  It serves as a simple example of
 * using those APIs to get basic status information.
 *
 * This does not have:
 *
 * - Robust error handling
 * - Colorized or paginated output formatting
 *
 * This does have:
 *
 * - Examples of translating command line arguments to the status
 *   options settings to mimic `git status` results.
 * - A sample status formatter that matches the default "long" format
 *   from `git status`
 * - A sample status formatter that matches the "short" format
 *
 * License: $(LINK2 https://creativecommons.org/publicdomain/zero/1.0/, CC0 1.0 Universal)
 */
module libgit2.example.status;


private static import core.stdc.stdio;
private static import core.stdc.string;
private static import libgit2.diff;
private static import libgit2.errors;
private static import libgit2.example.args;
private static import libgit2.example.common;
private static import libgit2.refs;
private static import libgit2.repository;
private static import libgit2.status;
private static import libgit2.submodule;
private static import libgit2.types;

public enum
{
	FORMAT_DEFAULT = 0,
	FORMAT_LONG = 1,
	FORMAT_SHORT = 2,
	FORMAT_PORCELAIN = 3,
}

public enum MAX_PATHSPEC = 8;

extern (C)
public struct status_opts
{
	libgit2.status.git_status_options statusopt;
	const (char)* repodir;
	char*[.MAX_PATHSPEC] pathspec;
	int npaths;
	int format;
	int zterm;
	int showbranch;
	int showsubmod;
	int repeat;
}

extern (C)
nothrow @nogc
public int lg2_status(libgit2.types.git_repository* repo, int argc, char** argv)

	in
	{
	}

	do
	{
		libgit2.types.git_status_list* status;
		.status_opts o = {libgit2.status.GIT_STATUS_OPTIONS_INIT(), ".".ptr};

		o.statusopt.show = libgit2.status.git_status_show_t.GIT_STATUS_SHOW_INDEX_AND_WORKDIR;
		o.statusopt.flags = libgit2.status.git_status_opt_t.GIT_STATUS_OPT_INCLUDE_UNTRACKED | libgit2.status.git_status_opt_t.GIT_STATUS_OPT_RENAMES_HEAD_TO_INDEX | libgit2.status.git_status_opt_t.GIT_STATUS_OPT_SORT_CASE_SENSITIVELY;

		.parse_opts(&o, argc, argv);

		if (libgit2.repository.git_repository_is_bare(repo)) {
			libgit2.example.common.fatal("Cannot report status on bare repository", libgit2.repository.git_repository_path(repo));
		}

	show_status:
		if (o.repeat) {
			core.stdc.stdio.printf("\033[H\033[2J");
		}

		/**
		 * Run status on the repository
		 *
		 * We use `libgit2.status.git_status_list_new()` to generate a list of status
		 * information which lets us iterate over it at our
		 * convenience and extract the data we want to show out of
		 * each entry.
		 *
		 * You can use `libgit2.status.git_status_foreach()` or
		 * `libgit2.status.git_status_foreach_ext()` if you'd prefer to execute a
		 * callback for each entry. The latter gives you more control
		 * about what results are presented.
		 */
		libgit2.example.common.check_lg2(libgit2.status.git_status_list_new(&status, repo, &o.statusopt), "Could not get status", null);

		if (o.showbranch) {
			.show_branch(repo, o.format);
		}

		if (o.showsubmod) {
			int submod_count = 0;
			libgit2.example.common.check_lg2(libgit2.submodule.git_submodule_foreach(repo, &.print_submod, &submod_count), "Cannot iterate submodules", o.repodir);
		}

		if (o.format == .FORMAT_LONG) {
			.print_long(status);
		} else {
			.print_short(repo, status);
		}

		libgit2.status.git_status_list_free(status);

		if (o.repeat) {
			libgit2.example.common.sleep(o.repeat);

			goto show_status;
		}

		return 0;
	}

/**
 * If the user asked for the branch, let's show the short name of the
 * branch.
 */
nothrow @nogc
private void show_branch(libgit2.types.git_repository* repo, int format)

	in
	{
	}

	do
	{
		const (char)* branch = null;
		libgit2.types.git_reference* head = null;

		int error = libgit2.repository.git_repository_head(&head, repo);

		if ((error == libgit2.errors.git_error_code.GIT_EUNBORNBRANCH) || (error == libgit2.errors.git_error_code.GIT_ENOTFOUND)) {
			branch = null;
		} else if (!error) {
			branch = libgit2.refs.git_reference_shorthand(head);
		} else {
			libgit2.example.common.check_lg2(error, "failed to get current branch", null);
		}

		if (format == .FORMAT_LONG) {
			core.stdc.stdio.printf("# On branch %s\n", (branch) ? (branch) : ("Not currently on any branch."));
		} else {
			core.stdc.stdio.printf("## %s\n", (branch) ? (branch) : ("HEAD (no branch)"));
		}

		libgit2.refs.git_reference_free(head);
	}

/**
 * This function print out an output similar to git's status command
 * in long form, including the command-line hints.
 */
nothrow @nogc
private void print_long(libgit2.types.git_status_list* status)

	in
	{
	}

	do
	{
		size_t maxi = libgit2.status.git_status_list_entrycount(status);
		const (libgit2.status.git_status_entry)* s;
		int header = 0;
		int rm_in_workdir = 0;

		/** Print index changes. */

		for (size_t i = 0; i < maxi; ++i) {
			const (char)* istatus = null;

			s = libgit2.status.git_status_byindex(status, i);

			if (s.status == libgit2.status.git_status_t.GIT_STATUS_CURRENT) {
				continue;
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_WT_DELETED) {
				rm_in_workdir = 1;
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_INDEX_NEW) {
				istatus = "new file: ";
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_INDEX_MODIFIED) {
				istatus = "modified: ";
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_INDEX_DELETED) {
				istatus = "deleted:  ";
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_INDEX_RENAMED) {
				istatus = "renamed:  ";
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_INDEX_TYPECHANGE) {
				istatus = "typechange:";
			}

			if (istatus == null) {
				continue;
			}

			if (!header) {
				core.stdc.stdio.printf("# Changes to be committed:\n");
				core.stdc.stdio.printf("#   (use \"git reset HEAD <file>...\" to unstage)\n");
				core.stdc.stdio.printf("#\n");
				header = 1;
			}

			const (char)* old_path = s.head_to_index.old_file.path;
			const (char)* new_path = s.head_to_index.new_file.path;

			if ((old_path) && (new_path) && (core.stdc.string.strcmp(old_path, new_path))) {
				core.stdc.stdio.printf("#\t%s  %s . %s\n", istatus, old_path, new_path);
			} else {
				core.stdc.stdio.printf("#\t%s  %s\n", istatus, (old_path) ? (old_path) : (new_path));
			}
		}

		int changes_in_index = 0;

		if (header) {
			changes_in_index = 1;
			core.stdc.stdio.printf("#\n");
		}

		header = 0;

		/** Print workdir changes to tracked files. */

		for (size_t i = 0; i < maxi; ++i) {
			const (char)* wstatus = null;

			s = libgit2.status.git_status_byindex(status, i);

			/**
			 * With `libgit2.status.git_status_opt_t.GIT_STATUS_OPT_INCLUDE_UNMODIFIED` (not used in this example)
			 * `index_to_workdir` may not be `null` even if there are
			 * no differences, in which case it will be a `libgit2.diff.git_delta_t.GIT_DELTA_UNMODIFIED`.
			 */
			if ((s.status == libgit2.status.git_status_t.GIT_STATUS_CURRENT) || (s.index_to_workdir == null)) {
				continue;
			}

			/** Print out the output since we know the file has some changes */
			if (s.status & libgit2.status.git_status_t.GIT_STATUS_WT_MODIFIED) {
				wstatus = "modified: ";
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_WT_DELETED) {
				wstatus = "deleted:  ";
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_WT_RENAMED) {
				wstatus = "renamed:  ";
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_WT_TYPECHANGE) {
				wstatus = "typechange:";
			}

			if (wstatus == null) {
				continue;
			}

			if (!header) {
				core.stdc.stdio.printf("# Changes not staged for commit:\n");
				core.stdc.stdio.printf("#   (use \"git add%s <file>...\" to update what will be committed)\n", (rm_in_workdir) ? (&("/rm\0"[0])) : (&("\0"[0])));
				core.stdc.stdio.printf("#   (use \"git checkout -- <file>...\" to discard changes in working directory)\n");
				core.stdc.stdio.printf("#\n");
				header = 1;
			}

			const (char)* old_path = s.index_to_workdir.old_file.path;
			const (char)* new_path = s.index_to_workdir.new_file.path;

			if ((old_path) && (new_path) && (core.stdc.string.strcmp(old_path, new_path))) {
				core.stdc.stdio.printf("#\t%s  %s . %s\n", wstatus, old_path, new_path);
			} else {
				core.stdc.stdio.printf("#\t%s  %s\n", wstatus, (old_path) ? (old_path) : (new_path));
			}
		}

		int changed_in_workdir = 0;

		if (header) {
			changed_in_workdir = 1;
			core.stdc.stdio.printf("#\n");
		}

		/** Print untracked files. */

		header = 0;

		for (size_t i = 0; i < maxi; ++i) {
			s = libgit2.status.git_status_byindex(status, i);

			if (s.status == libgit2.status.git_status_t.GIT_STATUS_WT_NEW) {
				if (!header) {
					core.stdc.stdio.printf("# Untracked files:\n");
					core.stdc.stdio.printf("#   (use \"git add <file>...\" to include in what will be committed)\n");
					core.stdc.stdio.printf("#\n");
					header = 1;
				}

				core.stdc.stdio.printf("#\t%s\n", s.index_to_workdir.old_file.path);
			}
		}

		header = 0;

		/** Print ignored files. */

		for (size_t i = 0; i < maxi; ++i) {
			s = libgit2.status.git_status_byindex(status, i);

			if (s.status == libgit2.status.git_status_t.GIT_STATUS_IGNORED) {
				if (!header) {
					core.stdc.stdio.printf("# Ignored files:\n");
					core.stdc.stdio.printf("#   (use \"git add -f <file>...\" to include in what will be committed)\n");
					core.stdc.stdio.printf("#\n");
					header = 1;
				}

				core.stdc.stdio.printf("#\t%s\n", s.index_to_workdir.old_file.path);
			}
		}

		if ((!changes_in_index) && (changed_in_workdir)) {
			core.stdc.stdio.printf("no changes added to commit (use \"git add\" and/or \"git commit -a\")\n");
		}
	}

/**
 * This version of the output prefixes each path with two status
 * columns and shows submodule status information.
 */
nothrow @nogc
private void print_short(libgit2.types.git_repository* repo, libgit2.types.git_status_list* status)

	in
	{
	}

	do
	{
		size_t maxi = libgit2.status.git_status_list_entrycount(status);

		for (size_t i = 0; i < maxi; ++i) {
			const (libgit2.status.git_status_entry)* s = libgit2.status.git_status_byindex(status, i);

			if (s.status == libgit2.status.git_status_t.GIT_STATUS_CURRENT) {
				continue;
			}

			const (char)* c = null;
			const (char)* b = null;
			const (char)* a = null;
			char wstatus = ' ';
			char istatus = ' ';
			const (char)* extra = "";

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_INDEX_NEW) {
				istatus = 'A';
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_INDEX_MODIFIED) {
				istatus = 'M';
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_INDEX_DELETED) {
				istatus = 'D';
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_INDEX_RENAMED) {
				istatus = 'R';
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_INDEX_TYPECHANGE) {
				istatus = 'T';
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_WT_NEW) {
				if (istatus == ' ') {
					istatus = '?';
				}

				wstatus = '?';
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_WT_MODIFIED) {
				wstatus = 'M';
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_WT_DELETED) {
				wstatus = 'D';
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_WT_RENAMED) {
				wstatus = 'R';
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_WT_TYPECHANGE) {
				wstatus = 'T';
			}

			if (s.status & libgit2.status.git_status_t.GIT_STATUS_IGNORED) {
				istatus = '!';
				wstatus = '!';
			}

			if (istatus == '?' && wstatus == '?') {
				continue;
			}

			/**
			 * A commit in a tree is how submodules are stored, so
			 * let's go take a look at its status.
			 */
			if ((s.index_to_workdir) && (s.index_to_workdir.new_file.mode == libgit2.types.git_filemode_t.GIT_FILEMODE_COMMIT)) {
				uint smstatus = 0;

				if (!libgit2.submodule.git_submodule_status(&smstatus, repo, s.index_to_workdir.new_file.path, libgit2.types.git_submodule_ignore_t.GIT_SUBMODULE_IGNORE_UNSPECIFIED)) {
					if (smstatus & libgit2.submodule.git_submodule_status_t.GIT_SUBMODULE_STATUS_WD_MODIFIED) {
						extra = " (new commits)";
					} else if (smstatus & libgit2.submodule.git_submodule_status_t.GIT_SUBMODULE_STATUS_WD_INDEX_MODIFIED) {
						extra = " (modified content)";
					} else if (smstatus & libgit2.submodule.git_submodule_status_t.GIT_SUBMODULE_STATUS_WD_WD_MODIFIED) {
						extra = " (modified content)";
					} else if (smstatus & libgit2.submodule.git_submodule_status_t.GIT_SUBMODULE_STATUS_WD_UNTRACKED) {
						extra = " (untracked content)";
					}
				}
			}

			/**
			 * Now that we have all the information, format the output.
			 */

			if (s.head_to_index) {
				a = s.head_to_index.old_file.path;
				b = s.head_to_index.new_file.path;
			}

			if (s.index_to_workdir) {
				if (a == null) {
					a = s.index_to_workdir.old_file.path;
				}

				if (b == null) {
					b = s.index_to_workdir.old_file.path;
				}

				c = s.index_to_workdir.new_file.path;
			}

			if (istatus == 'R') {
				if (wstatus == 'R') {
					core.stdc.stdio.printf("%c%c %s %s %s%s\n", istatus, wstatus, a, b, c, extra);
				} else {
					core.stdc.stdio.printf("%c%c %s %s%s\n", istatus, wstatus, a, b, extra);
				}
			} else {
				if (wstatus == 'R') {
					core.stdc.stdio.printf("%c%c %s %s%s\n", istatus, wstatus, a, c, extra);
				} else {
					core.stdc.stdio.printf("%c%c %s%s\n", istatus, wstatus, a, extra);
				}
			}
		}

		for (size_t i = 0; i < maxi; ++i) {
			const (libgit2.status.git_status_entry)* s = libgit2.status.git_status_byindex(status, i);

			if (s.status == libgit2.status.git_status_t.GIT_STATUS_WT_NEW) {
				core.stdc.stdio.printf("?? %s\n", s.index_to_workdir.old_file.path);
			}
		}
	}

extern (C)
nothrow @nogc
private int print_submod(libgit2.types.git_submodule* sm, const (char)* name, void* payload)

	in
	{
	}

	do
	{
		//cast(void)(name);
		int* count = cast(int*)(payload);

		if (*count == 0) {
			core.stdc.stdio.printf("# Submodules\n");
		}

		(*count)++;

		core.stdc.stdio.printf("# - submodule '%s' at %s\n", libgit2.submodule.git_submodule_name(sm), libgit2.submodule.git_submodule_path(sm));

		return 0;
	}

/**
 * Parse options that git's status command supports.
 */
nothrow @nogc
private void parse_opts(.status_opts* o, int argc, char** argv)

	in
	{
	}

	do
	{
		libgit2.example.args.args_info args = libgit2.example.args.ARGS_INFO_INIT(argc, argv);

		for (args.pos = 1; args.pos < argc; ++args.pos) {
			char* a = argv[args.pos];

			if (a[0] != '-') {
				if (o.npaths < .MAX_PATHSPEC) {
					o.pathspec[o.npaths++] = a;
				} else {
					libgit2.example.common.fatal("Example only supports a limited pathspec", null);
				}
			} else if ((!core.stdc.string.strcmp(a, "-s")) || (!core.stdc.string.strcmp(a, "--short"))) {
				o.format = .FORMAT_SHORT;
			} else if (!core.stdc.string.strcmp(a, "--long")) {
				o.format = .FORMAT_LONG;
			} else if (!core.stdc.string.strcmp(a, "--porcelain")) {
				o.format = .FORMAT_PORCELAIN;
			} else if ((!core.stdc.string.strcmp(a, "-b")) || (!core.stdc.string.strcmp(a, "--branch"))) {
				o.showbranch = 1;
			} else if (!core.stdc.string.strcmp(a, "-z")) {
				o.zterm = 1;

				if (o.format == .FORMAT_DEFAULT) {
					o.format = .FORMAT_PORCELAIN;
				}
			} else if (!core.stdc.string.strcmp(a, "--ignored")) {
				o.statusopt.flags |= libgit2.status.git_status_opt_t.GIT_STATUS_OPT_INCLUDE_IGNORED;
			} else if ((!core.stdc.string.strcmp(a, "-uno")) || (!core.stdc.string.strcmp(a, "--untracked-files=no"))) {
				o.statusopt.flags &= ~libgit2.status.git_status_opt_t.GIT_STATUS_OPT_INCLUDE_UNTRACKED;
			} else if ((!core.stdc.string.strcmp(a, "-unormal")) || (!core.stdc.string.strcmp(a, "--untracked-files=normal"))) {
				o.statusopt.flags |= libgit2.status.git_status_opt_t.GIT_STATUS_OPT_INCLUDE_UNTRACKED;
			} else if ((!core.stdc.string.strcmp(a, "-uall")) || (!core.stdc.string.strcmp(a, "--untracked-files=all"))) {
				o.statusopt.flags |= libgit2.status.git_status_opt_t.GIT_STATUS_OPT_INCLUDE_UNTRACKED | libgit2.status.git_status_opt_t.GIT_STATUS_OPT_RECURSE_UNTRACKED_DIRS;
			} else if (!core.stdc.string.strcmp(a, "--ignore-submodules=all")) {
				o.statusopt.flags |= libgit2.status.git_status_opt_t.GIT_STATUS_OPT_EXCLUDE_SUBMODULES;
			} else if (!core.stdc.string.strncmp(a, "--git-dir=", core.stdc.string.strlen("--git-dir="))) {
				o.repodir = a + core.stdc.string.strlen("--git-dir=");
			} else if (!core.stdc.string.strcmp(a, "--repeat")) {
				o.repeat = 10;
			} else if (libgit2.example.args.match_int_arg(&o.repeat, &args, "--repeat", 0)) {
				/* okay */
			} else if (!core.stdc.string.strcmp(a, "--list-submodules")) {
				o.showsubmod = 1;
			} else {
				libgit2.example.common.check_lg2(-1, "Unsupported option", a);
			}
		}

		if (o.format == .FORMAT_DEFAULT) {
			o.format = .FORMAT_LONG;
		}

		if (o.format == .FORMAT_LONG) {
			o.showbranch = 1;
		}

		if (o.npaths > 0) {
			o.statusopt.pathspec.strings = &(o.pathspec[0]);
			o.statusopt.pathspec.count = o.npaths;
		}
	}
