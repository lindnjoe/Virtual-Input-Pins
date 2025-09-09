import { Module } from 'vuex'
import { afc } from './afc'

export interface ServerState {}

const state: ServerState = {}

export const server: Module<ServerState, any> = {
  namespaced: true,
  state,
  modules: {
    afc,
  },
}
