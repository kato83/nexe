import typescript from '@rollup/plugin-typescript';
import { nodeResolve } from '@rollup/plugin-node-resolve';
import { terser } from "rollup-plugin-terser";
import commonjs from '@rollup/plugin-commonjs';
import json from '@rollup/plugin-json';

const entry = type => ({
  input: 'src/index.ts',
  // 出力指定
  output: {
    dir: `dist/js/`,
    format: type,
    exports: "named",
    sourcemap: true,
    name: 'nexe',
    entryFileNames: 'index.js',
  },
  plugins: [
    typescript({
      declarationDir: 'dist/js/',
    }),
    nodeResolve(),
    commonjs(),
    json(),
    terser({ output: { comments: /@license/i } }),
  ]
});

export default [
  entry('cjs'),
]
