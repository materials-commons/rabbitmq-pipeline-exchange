%%% ===================================================================
%%% @author V. Glenn Tarcea <gtarcea@umich.edu>
%%%
%%% @doc An exchange that supports dynamic creation of pipelines.
%%%
%%% @copyright Copyright (c) 2013, Regents of the University of Michigan.
%%% All rights reserved.
%%%
%%% Permission to use, copy, modify, and/or distribute this software for any
%%% purpose with or without fee is hereby granted, provided that the above
%%% copyright notice and this permission notice appear in all copies.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
%%% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
%%% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
%%% ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
%%% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
%%% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
%%% OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
%%% ===================================================================
-module(rabbitmq_pipeline_exchange).
-include_lib("rabbit_common/include/rabbit.hrl").
-behaviour(rabbit_exchange_type).
-export([description/0, serialise_events/0, route/2, validate/1]).
-export([create/2, delete/3, policy_changed/2, add_binding/3, remove_bindings/3]).
-export([assert_args_equivalence/2, init/0]).

-define(EXCHANGE_TYPE, <<"x-pipeline">>).

-rabbit_boot_step
    (
        {rabbit_exchange_type_pipeline_registry
            [
                {description, "exchange type x-pipeline: registry"},
                {mfa, {rabbit_registry, register, [exchange, ?EXCHANGE_TYPE, ?MODULE]}},
                {requires, rabbit_registry},
                {enables, kernel_ready}
            ]
        }
    ).

-rabbit_boot_step
    (
        {rabbit_exchange_type_pipeline_configuration,
            [
                {description, "exchange type x-pipeline: configuration"},
                {mfa, {?MODULE, init, []}},
                {enables, external_infrastructure}
            ]
        }
    ).

init() -> ok.

description() ->
    [{name, ?EXCHANGE_TYPE}, {description, <<"exchange type pipeline">>}].

serialise_events() -> false.

route(#exchange{} = Exchange, #delivery{} = Delivery) -> ok.

validate(_Exchange) -> ok.

create(_Tx, _Exchange) -> ok.

delete(_Tx, _Exchange, _Bindings) -> ok.

policy_changed(_S, _Exchange1, _Exchange2) -> ok.

add_binding(_S, _Exchange, _Binding) -> ok.

remove_binding(_S, _Exchange, _Bindings) -> ok.

assert_args_equivalence(Exchange, Args) ->
    rabbit_exchange:assert_args_equivalence(Exchange, Args).
