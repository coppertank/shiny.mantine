import React from 'react';
import { reorder, styleStringToObject, createBuildElement } from './serialization';

describe('reorder()', () => {
  it('moves an item from startIndex to endIndex without mutating the input', () => {
    const list = ['a', 'b', 'c', 'd'];
    const result = reorder(list, 0, 2);

    expect(result).toEqual(['b', 'c', 'a', 'd']);
    expect(list).toEqual(['a', 'b', 'c', 'd']);
  });

  it('moving an item backwards works the same way', () => {
    expect(reorder(['a', 'b', 'c', 'd'], 3, 1)).toEqual(['a', 'd', 'b', 'c']);
  });

  it('is a no-op when startIndex === endIndex', () => {
    expect(reorder(['a', 'b', 'c'], 1, 1)).toEqual(['a', 'b', 'c']);
  });
});

describe('styleStringToObject()', () => {
  it('parses a CSS declaration string into a camelCase-free object keyed by property name', () => {
    expect(styleStringToObject('color: red; font-weight: bold;')).toEqual({
      color: 'red',
      'font-weight': 'bold',
    });
  });

  it('trims whitespace and lowercases property names', () => {
    expect(styleStringToObject('  Color :  Blue  ')).toEqual({ color: 'Blue' });
  });

  it('ignores empty declarations from trailing/duplicate semicolons', () => {
    expect(styleStringToObject('color: red;;')).toEqual({ color: 'red' });
  });

  it('returns an empty object for an empty string', () => {
    expect(styleStringToObject('')).toEqual({});
  });
});

describe('createBuildElement()', () => {
  function FakeComponent() { return null; }
  const components = { FakeComponent };
  const { buildElement, buildProps } = createBuildElement(components);

  it('returns null for null/undefined nodes', () => {
    expect(buildElement(null)).toBeNull();
    expect(buildElement(undefined)).toBeNull();
  });

  it('unwraps a "raw" node to its plain value', () => {
    expect(buildElement({ type: 'raw', value: 42 })).toBe(42);
    expect(buildElement({ type: 'raw', value: 'hello' })).toBe('hello');
  });

  it('builds a React element for a known "element" node, resolved from the components registry', () => {
    const el = buildElement({
      type: 'element',
      name: 'FakeComponent',
      props: { label: { type: 'raw', value: 'hi' } },
    });

    expect(React.isValidElement(el)).toBe(true);
    expect(el.type).toBe(FakeComponent);
    expect(el.props).toEqual({ label: 'hi' });
  });

  it('throws a descriptive error for an unregistered component name', () => {
    expect(() => buildElement({ type: 'element', name: 'Nope', props: {} }))
      .toThrow('shiny.mantine: unknown component "Nope"');
  });

  it('builds an array of keyed React elements from an "array" node', () => {
    const node = {
      type: 'array',
      value: [
        { type: 'element', name: 'FakeComponent', props: {} },
        { type: 'element', name: 'FakeComponent', props: {} },
      ],
    };
    const result = buildElement(node);

    expect(result).toHaveLength(2);
    expect(result[0].key).toBe('0');
    expect(result[1].key).toBe('1');
  });

  it('builds a plain nested object (not a React element) from an "object" node', () => {
    const node = {
      type: 'object',
      value: { a: { type: 'raw', value: 1 }, b: { type: 'raw', value: 2 } },
    };
    expect(buildElement(node)).toEqual({ a: 1, b: 2 });
  });

  it('renders an "html" node as a div with dangerouslySetInnerHTML', () => {
    const el = buildElement({ type: 'html', value: '<span>hi</span>' });
    expect(el.type).toBe('div');
    expect(el.props.dangerouslySetInnerHTML).toEqual({ __html: '<span>hi</span>' });
  });

  it('buildProps() converts a string "style" prop into an object automatically', () => {
    const props = buildProps({
      style: { type: 'raw', value: 'color: red; margin: 0;' },
      label: { type: 'raw', value: 'hi' },
    });
    expect(props.style).toEqual({ color: 'red', margin: '0' });
    expect(props.label).toBe('hi');
  });

  it('buildProps() leaves a non-string "style" prop (already an object) untouched', () => {
    const props = buildProps({
      style: { type: 'object', value: { color: { type: 'raw', value: 'blue' } } },
    });
    expect(props.style).toEqual({ color: 'blue' });
  });
});
