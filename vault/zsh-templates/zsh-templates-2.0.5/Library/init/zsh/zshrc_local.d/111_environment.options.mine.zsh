

         #################################################
         #################################################
         #                                               #
         #    $ZDOT/zshrc.d/environment.options.zsh      #
         #                                               #
         #################################################
         #################################################



# File:  $ZDOT/zshrc.d/environment.options.zsh

# sourced from /etc/zshrc

# Version: 2.0.0

###############################################################################

#  Created by William G. Scott on January 2, 2009.
#  Copyright (c) . All rights reserved.


#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
#    USA
#
#    cf. URL:   http://www.fsf.org/licensing/licenses/gpl.html
#
###############################################################################


##########################################################################
#
#             Most of what follows is distributed with ZSH:
#             Housekeeping, Completions, environment Options,
#             Keybindings and and zstyles
#
##########################################################################



if [[ -o interactive ]]; then

    HISTSIZE=500
    if (( ! EUID )); then
        HISTFILE=~/.zsh/zsh_history_root
    else
        HISTFILE=~/.zsh/zsh_history
    fi
    SAVEHIST=500
    export HISTFILE HISTSIZE SAVEHIST

    #---------------------------------
    # setting zsh environment options
    #---------------------------------

    zshrc_load_status 'setting options'

    setopt                       \
            append_history       \
            auto_list            \
            auto_menu            \
            auto_param_keys      \
            auto_pushd           \
            bad_pattern          \
            bang_hist            \
            brace_ccl            \
            correct_all          \
            cdable_vars          \
         NO_chase_links          \
         NO_clobber              \
            complete_in_word     \
         NO_csh_junkie_loops     \
         NO_csh_junkie_quotes    \
         NO_csh_null_glob        \
            extended_glob        \
            function_argzero     \
            glob                 \
         NO_glob_assign          \
            glob_complete        \
         NO_glob_dots            \
         NO_glob_subst           \
            hash_cmds            \
            hash_dirs            \
            hash_list_all        \
            hist_allow_clobber   \
            hist_beep            \
         NO_hup                  \
         NO_ignore_braces        \
            ignore_eof           \
            interactive_comments \
         NO_list_ambiguous       \
            list_types           \
            long_list_jobs       \
            magic_equal_subst    \
         NO_mark_dirs            \
            multios              \
            nomatch              \
            nohup                \
            notify               \
         NO_null_glob            \
            path_dirs            \
            posix_builtins       \
         NO_print_exit_value     \
            pushd_ignore_dups    \
         NO_pushd_minus          \
            pushd_to_home        \
            rc_expand_param      \
         NO_rc_quotes            \
         NO_rm_star_silent       \
         NO_sh_file_expansion    \
            short_loops          \
         NO_single_line_zle      \
         NO_sun_keyboard_hack    \
            unset                \
         NO_verbose              \
            share_history
    #        zle       \
    #     NO_all_export           \
    #        always_last_prompt   \
    #     NO_always_to_end        \
    #     NO_auto_cd              \
    #     NO_auto_name_dirs       \
    #        auto_param_slash     \
    #        auto_remove_slash    \
    #     NO_auto_resume          \
    #     NO_beep                 \
    #     NO_bsd_echo             \
    #        complete_aliases     \
    #     NO_correct              \
    #        csh_junkie_history   \
    #        equals               \
    #        extended_history     \
    #        hist_ignore_dups     \
    #        hist_ignore_space    \
    #     NO_hist_no_store        \
    #        hist_verify          \
    #     NO_ignore_eof           \
    #     NO_list_beep            \
    #     NO_mail_warning         \
    #     NO_menu_complete        \
    #        numeric_glob_sort    \
    #     NO_overstrike           \
    #     NO_prompt_cr            \
    #        prompt_subst         \
    #        pushd_silent         \
    #        sh_option_letters    \
    #        NO_sh_word_split     \

fi
