import React from 'react';
import { Dropzone as MantineDropzone } from '@mantine/dropzone';
import '@mantine/dropzone/styles.css';
import { setShinyValue } from '../shared';

// Dropzone (file upload): reports the metadata of dropped files
// (name/size/type) to Shiny - file content is not uploaded over this
// channel, it's meant to let the server react (validation, kicking off a
// real upload via a regular shiny::fileInput() alongside it, ...).
function ShinyDropzone({
  inputId, children, onDrop, onReject, ...props
}) {
  return React.createElement(MantineDropzone, {
    ...props,
    onDrop: (files) => {
      // Wrapped in { count, files } (instead of a bare array) because a
      // JSON array with a single object gets "flattened" by R differently
      // than one with several objects (a classic jsonlite/Shiny gotcha) -
      // making `length(input$x)` unreliable for counting files. `count` is
      // always a single, stable number.
      const meta = files.map((f) => ({ name: f.name, size: f.size, type: f.type }));
      setShinyValue(inputId, { count: files.length, files: meta }, { priority: 'event' });
      if (onDrop) onDrop(files);
    },
    onReject: (fileRejections) => {
      setShinyValue(`${inputId}_rejected`, fileRejections.length, { priority: 'event' });
      if (onReject) onReject(fileRejections);
    },
  }, children);
}

export const components = {
  Dropzone: ShinyDropzone,
  'Dropzone.Accept': MantineDropzone.Accept,
  'Dropzone.Reject': MantineDropzone.Reject,
  'Dropzone.Idle': MantineDropzone.Idle,
};
